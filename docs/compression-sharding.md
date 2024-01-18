**Table of Contents**

- [Generating mirror manifests with compressed registry paths](#generating-mirror-manifests-with-compressed-registry-paths)
  - [Compressing the target registry](#compressing-the-target-registry)
  - [Compressing the intermediate and final registries](#compressing-the-intermediate-and-final-registries)
- [Sharding the image-digest-mirror-set.yaml and image-content-source-policy.yaml files](#sharding-the-image-digest-mirror-setyaml-and-image-content-source-policyyaml-files)

# Generating mirror manifests with compressed registry paths

Registry path compression, available with version `v1.9.0` of the ibm-pak plug-in, allows reducing the number of component paths in a target image repository by converting paths to dashes ("-"). This feature allows compressing the paths for both the intermediate and final registries.

Compression is enabled using two flags:  `--max-components` and `--final-max-components`, each supporting the following values:
- `0` - compression disabled (default)
- `>=2` - path components compressed from right to left to honor the value provided. 

For example, if the source repository path is `quay.io/org/subrepo/repo` and `--max-components 2` then it will be converted to `quay.io/org/subrepo-repo`.

Registry path compression changes how the ImageDigestMirrorSet (IDMS) and ImageContentSourcePolicy (ICSP) resources are created:
- When disabled (the default), the `imageDigestMirrors` of the IDMS (or `repositoryDigestMirrors` of the ICSP) contains one entry for each of the first component path (also known as the "namespace"), for example: `icr.io/cpopen`.
- When enabled, the `imageDigestMirrors` of the IDMS (or `repositoryDigestMirrors` of the ICSP) is expanded to one entry per repository (the full image path). Because this can produce a large number of entries, sharding is used to divide the IDMS (or ICSP) into multiple resources.  Learn more here: [Sharding IDMS and ICSP file](#sharding-the-image-digest-mirror-setyaml-and-image-content-source-policyyaml-files).

> Note:  All of the examples in this document use an abbreviated image digest of (`@sha256:123...`) for readability).


## Compressing the target registry

Set the compression of the target registry's image repository paths by setting the `--max-components` flag. 

The `--max-components` value specifies the maximum number of path components allowed in a target registry image repository mapping (0: all paths used, 1: error - not allowed, 2 and more: paths compressed from right to left to honor the provided maximum components). 

Command format: 

```
oc ibm-pak generate mirror-manifests <case name> <target registry> --version <case version> --max-components <path components>  
```

Generated files:

```
catalog-sources.yaml
image-content-source-policy.yaml
images-mapping.txt
```

What will be changed as a result of compression:

1. The `catalog-sources.yaml` `spec.image` changes as follows:

    Without compression: 
    ```
    image: registry.com/a/b/c/cpopen/ibm-cloudpak@sha256:123...
    ```
    With `--max-components 2` compression:
    ```
    image: registry.com/a/b-c-cpopen-ibm-cloudpak@sha256:123...  
    ```

2. The `image-content-source-policy.yaml` `spec.repositoryDigestMirrors` changes as follows (note the change from "namespace" to "repository" entries):

    Without compression (scoped to the source repository namespace / left-most path): 
    ```
    spec:
      repositoryDigestMirrors:
      - mirrors:
        - registry.com/a/b/c/kubebuilder
        source: gcr.io/kubebuilder
      - mirrors:
        - registry.com/a/b/c/cpopen
        source: icr.io/cpopen
    ```
    
    With `--max-components 2` compression (scoped to the repository):
    ```
    spec:
      repositoryDigestMirrors:
      - mirrors:
        - registry.com/a/b-c-kubebuilder-kube-rbac-proxy
        source: gcr.io/kubebuilder/kube-rbac-proxy
      - mirrors:
        - registry.com/a/b-c-cpopen-ibm-cloudpak-catalog
        source: icr.io/cpopen/ibm-cloudpak-catalog
      - mirrors:
        - registry.com/a/b-c-cpopen-ibm-cloudpak-operator
        source: icr.io/cpopen/ibm-cloudpak-operator
      - mirrors:
        - registry.com/a/b-c-cpopen-ibm-cloudpak-operator-bundle
        source: icr.io/cpopen/ibm-cloudpak-operator-bundle
    ```

3. The `images-mapping.txt` changes all target paths (on the right of '=' sign):
    
    Without compression: 
    ```
    icr.io/cpopen/ibm-cloudpak-operator@sha256:123...=registry.com/a/b/c/cpopen/ibm-cloudpak-operator:v1.0.6
    ```
    With `--max-components 2` compression:
    ```
    icr.io/cpopen/ibm-cloudpak-operator@sha256:123...=registry.com/a/b-c-cpopen-ibm-cloudpak-operator:v1.0.6
    ```


## Compressing the intermediate and final registries

An intermediate registry is used for advanced use cases where the images must be mirrored to a intermediate file system or registry prior to mirroring to the final destination registry, and is enabled with the `--final-registry` flag:  
  Source Registry -> Intermediate Target Registry -> Final Registry

When using an intermediate registry for mirroring, the compression level can be set independently for the target and final registries by using the `--final-max-components` flag:

- Use `--max-components` to set the number of path components allowed for target, intermediate registry.  

  If the target registry is a filesystem path (starts with `file://`), compression will not be applied to path.

- Use `--final-max-components` to override `--max-components`, and set the number of path components allowed for the final destination registry:

  The value provided to `--final-max-components` cannot be greater than value provided to `--max-components`. If `--final-max-components` is set to 0 (default) or is greater than `--max-components`, `--final-max-components` is set to the `--max-components` value. 

Command format: 

`oc ibm-pak generate mirror-manifests <case name> <target registry> --version <case version> --final-registry <final registry> --max-components <path components> --final-max-components <path components> `

Generated files (if intermediate registry is not a filepath):

```
catalog-sources.yaml
image-content-source-policy.yaml
images-mapping-to-registry.txt
images-mapping-from-registry.txt
```

What will be changed because of compression:
in the following examples we are using values: 
 - `registry.com/a/b/c` - target registry (intermediate)
 - `finalreg.com/a/b/c` - final registry

1. The `catalog-sources.yaml` `spec.image` changes as follows:

    Without compression: 
    ```
    image: finalreg.com/a/b/c/cpopen/ibm-cloudpak-catalog@sha256:123...
    ```
    With `--max-components 3` and `--final-max-components 2` compression:
    ```
    image: finalreg.com/a/b-c-cpopen-ibm-cloudpak-catalog@sha256:123...
    ```

2. The `image-content-source-policy.yaml` `spec.repositoryDigestMirrors` changes as follows:

    Without compression (scoped to the source repository namespace / left-most path): 
    ```
    spec:
      repositoryDigestMirrors:
      - mirrors:
        - finalreg.com/a/b/c/kubebuilder
        source: gcr.io/kubebuilder
      - mirrors:
        - finalreg.com/a/b/c/cpopen
        source: icr.io/cpopen
    ```
    With `--max-components 3` and `--final-max-components 2` compression (scoped to the repository):
    ```
    spec:
      repositoryDigestMirrors:
      - mirrors:
        - finalreg.com/a/b-c-kubebuilder-kube-rbac-proxy
        source: gcr.io/kubebuilder/kube-rbac-proxy
      - mirrors:
        - finalreg.com/a/b-c-cpopen-ibm-cloudpak-catalog
        source: icr.io/cpopen/ibm-cloudpak-catalog
      - mirrors:
        - finalreg.com/a/b-c-cpopen-ibm-cloudpak-operator
        source: icr.io/cpopen/ibm-cloudpak-operator
      - mirrors:
        - finalreg.com/a/b-c-cpopen-ibm-cloudpak-operator-bundle
        source: icr.io/cpopen/ibm-cloudpak-operator-bundle
    ```

3. The `images-mapping-to-registry.txt`changes all target paths to the intermediate, target registry (`--max-components` value) as follows:

    Without compression: 
    ```
    icr.io/cpopen/ibm-cloudpak-operator@sha256:123...=registry.com/a/b/c/cpopen/ibm-cloudpak-operator:v1.0.6
    ```
    With `--max-components 3` and `--final-max-components 2` compression:
    ```
    icr.io/cpopen/ibm-cloudpak-operator@sha256:123...=registry.com/a/b/c-cpopen-ibm-cloudpak-operator:v1.0.6
    ```

4. The `images-mapping-from-registry.txt` changes the source and target paths using the respective (`--max-components`and `--final-max-components` values) as follows: 

    Without compression: 
    ```
    registry.com/a/b/c/cpopen/ibm-cloudpak-operator@sha256:123...=finalreg.com/a/b/c/cpopen/ibm-cloudpak-operator:v1.0.6

    ```
    With `--max-components 3` and `--final-max-components 2` compression:
    ```
    registry.com/a/b/c-cpopen-ibm-cloudpak-operator@sha256:123...=finalreg.com/a/b-c-cpopen-ibm-cloudpak-operator:v1.0.6
    ```

Generated files (if the intermediate registry is a filepath):

```
catalog-sources.yaml
image-content-source-policy.yaml
images-mapping-to-filesystem.txt
images-mapping-from-filesystem.txt
```
Changes for the above will be analogous to files generated for registry scenario, except for filesystem paths that will not be compressed.


# Sharding the image-digest-mirror-set.yaml and image-content-source-policy.yaml files

Kubernetes resources have limits on the size of their content, so if you create a YAML that is too large, the resource won't be created when you apply the resource. To solve this problem, the resource is divided (sharded) into smaller sized resources and placed into a multi document YAML file (i.e., one file with multiple Kubernetes resources within it).

IDMS and ICSP sharding is only used for `image-digest-mirror-set.yaml` and `image-content-source-policy.yaml` files created when compression is enabled, appending a `-<integer>` starting with 0 to each resource name. Use the `--max-idms-size` flag to override the maximum size of each ImageDigestMirrorSet resource. For ImageContentSourcePolicy resource use  `--max-icsp-size` flag accordingly.

Example. 
1. The compressed `image-digest-mirror-set.yaml` with `--max-components 2` creates 1 shard:
   
    ```
    apiVersion: config.openshift.io/v1
    kind: ImageDigestMirrorSet
    metadata:
      name: ibm-cloudpak-0
    spec:
      imageDigestMirrors:
      - mirrors:
        - registry.com/a/b-c-kubebuilder-kube-rbac-proxy
        source: gcr.io/kubebuilder/kube-rbac-proxy
      - mirrors:
        - registry.com/a/b-c-cpopen-ibm-cloudpak-catalog
        source: icr.io/cpopen/ibm-cloudpak-catalog
      - mirrors:
        - registry.com/a/b-c-cpopen-ibm-cloudpak-operator
        source: icr.io/cpopen/ibm-cloudpak-operator
      - mirrors:
        - registry.com/a/b-c-cpopen-ibm-cloudpak-operator-bundle
        source: icr.io/cpopen/ibm-cloudpak-operator-bundle
    ```

2. The compressed `image-digest-mirror-set.yaml` with `--max-components 2` and `max-idms-size 400` creates 3 shards:

    ```
    apiVersion: config.openshift.io/v1
    kind: ImageDigestMirrorSet
    metadata:
      name: ibm-cloudpak-0
    spec:
      imageDigestMirrors:
      - mirrors:
        - registry.com/a/b-c-kubebuilder-kube-rbac-proxy
        source: gcr.io/kubebuilder/kube-rbac-proxy
      - mirrors:
        - registry.com/a/b-c-cpopen-ibm-cloudpak-catalog
        source: icr.io/cpopen/ibm-cloudpak-catalog
    ---
    apiVersion: config.openshift.io/v1
    kind: ImageDigestMirrorSet
    metadata:
      name: ibm-cloudpak-1
    spec:
      imageDigestMirrors:
      - mirrors:
        - registry.com/a/b-c-cpopen-ibm-cloudpak-operator
        source: icr.io/cpopen/ibm-cloudpak-operator
    ---
    apiVersion: config.openshift.io/v1
    kind: ImageDigestMirrorSet
    metadata:
      name: ibm-cloudpak-2
    spec:
      imageDigestMirrors:
      - mirrors:
        - registry.com/a/b-c-cpopen-ibm-cloudpak-operator-bundle
        source: icr.io/cpopen/ibm-cloudpak-operator-bundle
    ```

