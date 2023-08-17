<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [oc ibm-pak config repo](#oc-ibm-pak-config-repo)
- [oc ibm-pak config locale](#oc-ibm-pak-config-locale)
- [oc ibm-pak config color](#oc-ibm-pak-config-color)
- [oc ibm-pak config mirror-tools](#oc-ibm-pak-config-mirror-tools)
- [oc ibm-pak config mirror-tools oc-image-mirror](#oc-ibm-pak-config-mirror-tools-oc-image-mirror)
- [oc ibm-pak config mirror-tools oc-mirror](#oc-ibm-pak-config-mirror-tools-oc-mirror)
- [oc ibm-pak config catalog-builder](#oc-ibm-pak-config-catalog-builder)
- [oc ibm-pak config](#oc-ibm-pak-config)
- [oc ibm-pak get](#oc-ibm-pak-get)
- [oc ibm-pak generate mirror-manifests](#oc-ibm-pak-generate-mirror-manifests)
- [oc ibm-pak describe](#oc-ibm-pak-describe)
- [oc ibm-pak generate online-manifests](#oc-ibm-pak-generate-online-manifests)
- [oc ibm-pak launch](#oc-ibm-pak-launch)
- [oc ibm-pak list](#oc-ibm-pak-list)
- [oc ibm-pak verify](#oc-ibm-pak-verify)

# oc ibm-pak config repo
Configure the plug-in to download CASEs from the raw github url or as OCI artifacts from IBM Cloud Container Registry (ICCR).

Usage:
```
oc ibm-pak config repo <repository name> [--url=<raw github url|oci registry url>] [--delete|--enable]

Flags:
    -d, --delete                 deletes the repository with the <repository name> argument (optional)
    -e, --enable                 Marks the repository with the <repository name> argument to be selected for downloading a CASE. Only one repo can be configured to be enabled (optional)
    -r, --url "raw github url"   "raw github url" for a CASE repository (default "https://github.com/IBM/cloud-pak/raw/master/repo/case/")
    -h, --help                   help for repo
```

Example:
```
1) Add a repository with default value (default https://github.com/IBM/cloud-pak/raw/master/repo/case/)
oc ibm-pak config repo 'IBM Cloud-Pak Github Repo'

2) Add/Update a repository
oc ibm-pak config repo 'IBM Cloud-Pak OCI registry' --url oci:cp.icr.io/cpopen

3) Remove a repository
oc ibm-pak config repo 'IBM Cloud-Pak OCI registry' --delete

4) Enable a repository
oc ibm-pak config repo 'IBM Cloud-Pak Github Repo'  --enable

oc ibm-pak config repo 'IBM Cloud-Pak Github Repo' --url https://github.com/IBM/cloud-pak/raw/master/repo/case/ --enable
```

# oc ibm-pak config locale
Configure locale for plug-in.

Usage:
```
oc ibm-pak config locale  --language=<language>

Flags:
    -l, --language string   Set default language, an empty value will trigger an auto detection of the language
    -h, --help              help for locale
```

Example: 
```
1) Update Locale
oc ibm-pak config locale -l fr_FR

2) Reset locale to default, system detects the locale to use
oc ibm-pak config locale -l ""
```

# oc ibm-pak config color
Enable/disable color output (optional with v1.4.0 and later)

Usage:
```
oc ibm-pak config color --enable <true|false>

Flags:
    -e, --enable string   Enable coloring the plugin's command output in the console
    -h, --help            help for color
```

Example:
```
1) Enable color output
oc ibm-pak config color --enable true

2) Disable color output
oc ibm-pak config color --enable false
```

# oc ibm-pak config mirror-tools
Configure the mirror-tools (with v1.8.0 and later)

Usage:
```
oc ibm-pak config mirror-tools --enabled <oc-image-mirror|oc-mirror>

Flags:
    -e, --enabled string   Set the enabled tool to be used from the following list: oc-image-mirror, oc-mirror (default "oc-image-mirror")
    -h, --help             help for mirror-tools
```

Example: 
```
1) Enable oc image mirror tool
oc ibm-pak config mirror-tools --enabled oc-image-mirror

2) Enable oc mirror tool
oc ibm-pak config mirror-tools --enabled oc-mirror
```

# oc ibm-pak config mirror-tools oc-image-mirror
Configure the oc-image-mirror tool settings (with v1.8.0 and later)

Usage:
```
oc ibm-pak config mirror-tools oc-image-mirror < --connected-flags|--disconnected-target-flags|--disconnected-final-flags > <flags>

Flags:
    --connected-flags string             Set the connected mirroring flags for configuring the oc image mirror tool in connected mode (Setting this flag as AUTO_GENERATE will make the plugin use --filter-by-os '.*' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1) (default "AUTO_GENERATE")

    --disconnected-final-flags string    Set the disconnected mirroring to final flags for configuring the oc image mirror tool to final registry in disconnected mode (Setting this flag as AUTO_GENERATE will make the plugin use --filter-by-os '.*' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --from-dir "$IMAGE_PATH") (default "AUTO_GENERATE")

    --disconnected-target-flags string   Set the disconnected mirroring to target flags for configuring the oc image mirror tool to target filesystem or registry in disconnected mode (Setting this flag as AUTO_GENERATE will make the plugin use --filter-by-os '.*' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --dir "$IMAGE_PATH") (default "AUTO_GENERATE")

    -h, --help                           help for oc-image-mirror
```

Example: 
```
1) Update connected-flags
oc ibm-pak config mirror-tools oc-image-mirror --connected-flags '--filter-by-os '\''.*'\'' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1'

2) Reset connected-flags to AUTO_GENERATE
oc ibm-pak config mirror-tools oc-image-mirror --connected-flags AUTO_GENERATE

3) Update disconnected-target-flags
oc ibm-pak config mirror-tools oc-image-mirror --disconnected-target-flags '--filter-by-os '\''.*'\'' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --dir "$IMAGE_PATH"'

4) Update disconnected-final-flags
oc ibm-pak config mirror-tools oc-image-mirror --disconnected-final-flags '--filter-by-os '\''.*'\'' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --from-dir "$IMAGE_PATH"'
```

# oc ibm-pak config mirror-tools oc-mirror
Configure the oc-mirror tool settings (with v1.8.0 and later)

Usage:
```
oc ibm-pak config mirror-tools oc-mirror --storage=<storage> [--storage-skip-tls] --target-catalog=<target-catalog> --target-tag=<target-tag> < --connected-flags|--disconnected-target-flags|--disconnected-final-flags > <flags>

Flags:
    --connected-flags string             Set the connected mirroring flags for configuring the oc mirror tool in connected mode (Setting this flag as AUTO_GENERATE will make the plugin use --dest-skip-tls --max-per-registry=6) (default "AUTO_GENERATE")
    
    --disconnected-final-flags string    Set the disconnected mirroring to final flags for configuring the oc mirror tool to final registry in disconnected mode (Setting this flag as AUTO_GENERATE will make the plugin use --dest-skip-tls --from=sequence_file.tar) (default "AUTO_GENERATE")
    
    --disconnected-target-flags string   Set the disconnected mirroring to target flags for configuring the oc mirror tool to target filesystem or registry in disconnected mode (Setting this flag as AUTO_GENERATE will make the plugin use --dest-skip-tls --max-per-registry=6) (default "AUTO_GENERATE")
    
    -h, --help                           help for oc-mirror
    
    -s, --storage string                 Set the storage via a file or a docker reference

    --storage-skip-tls                   Disable TLS verification when using a registry server as storage (applies only to docker registry)
    
    --target-catalog string              Set the target catalog (including registry path) (default "ibm-catalog")
    
    --target-tag string                  Set the target catalog tag (Setting this flag as AUTO_GENERATE will make the plugin generate target tag dynamically) (default "AUTO_GENERATE")
```

Example: 
```
1) Configure a local path based storage 
oc ibm-pak config mirror-tools oc-mirror --storage file:///tmp/local-backed

2) Configure a registry based storage for oc-mirror
oc ibm-pak config mirror-tools oc-mirror --storage docker://quay.io/foo/bar:example

3) Configure a registry based storage for oc-mirror allowing insecure connections 
oc ibm-pak config mirror-tools oc-mirror --storage docker://quay.io/foo/bar:example --storage-skip-tls

4) Configure a target catalog and target tag
oc ibm-pak config mirror-tools oc-mirror --target-catalog ibm-catalog --target-tag latest

5) Update connected-flags
oc ibm-pak config mirror-tools oc-mirror --connected-flags '--dest-skip-tls --max-per-registry=6'

6) Reset connected-flags to AUTO_GENERATE
oc ibm-pak config mirror-tools oc-mirror --connected-flags AUTO_GENERATE

7) Update disconnected-target-flags
oc ibm-pak config mirror-tools oc-mirror --disconnected-target-flags '--dest-skip-tls --max-per-registry=6'

8) Update disconnected-final-flags
oc ibm-pak config mirror-tools oc-mirror --disconnected-final-flags '--dest-skip-tls --from=sequence_file.tar'
```

# oc ibm-pak config catalog-builder
Configures the catalog-builder settings (with v1.8.0 and later)

Usage:
```
oc ibm-pak config catalog-builder --base-image myregistry.com/images/base-image:1.0

Flags:
    --base-image string   Set the base image for fbc catalog (Setting this flag as AUTO_GENERATE will make the plugin use icr.io/cpopen/ibm-operator-catalog:fbc-base-latest) (default "AUTO_GENERATE")
  -h, --help              help for catalog-builder
```

Example:
```
1) Configure a catalog base image used during curation
oc ibm-pak config catalog-builder --base-image icr.io/cpopen/ibm-operator-catalog:fbc-base-latest

2) Reset catalog base image to AUTO_GENERATE
oc ibm-pak config catalog-builder --base-image AUTO_GENERATE
```

# oc ibm-pak config
To see the existing configuration details for plug-in.

Usage:
```
oc ibm-pak config [-o yaml|json]
```

Example Output : 
```

Config file

Version: 1.1.0

Repository Config

Name                        CASE Repo URL                                          
----                        -------------                                          
IBM Cloud-Pak Github Repo * https://github.com/IBM/cloud-pak/raw/master/repo/case/ 
IBM Cloud-Pak OCI registry  oci:cp.icr.io/cpopen                                   

Locale Config

Language: en_US

Color Config

Enabled: true

Mirror Tools Config

oc image mirror: 
---------------
Connected Mirroring Flags:
  AUTO_GENERATE (--filter-by-os '.*' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1)

Disconnected Mirroring Flags:
  To Target FileSystem or Registry:
    AUTO_GENERATE (--filter-by-os '.*' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --dir "$IMAGE_PATH")

  To Final Registry:
    AUTO_GENERATE (--filter-by-os '.*' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --from-dir "$IMAGE_PATH")

oc mirror: 
---------
Local storage config:
  Path: /Users/manojishwarbhaipaladiya/.ibm-pak/oc-mirror-storage

Connected Mirroring Flags:
  AUTO_GENERATE (--dest-skip-tls --max-per-registry=6)

Disconnected Mirroring Flags:
  To Target FileSystem or Registry:
    AUTO_GENERATE (--dest-skip-tls --max-per-registry=6)

  To Final Registry:
    AUTO_GENERATE (--dest-skip-tls --from=sequence_file.tar)

Target catalog: ibm-catalog

Target tag: AUTO_GENERATE


Enabled tool: oc image mirror

Catalog Builder Config

Base image: AUTO_GENERATE (icr.io/cpopen/ibm-operator-catalog:fbc-base-latest)

```

# oc ibm-pak get
Download a CASE or a set of components referred by a ComponentSetConfig file from a repository like github, oci-compliant registry etc.

Usage:
```
oc ibm-pak get ( <case name> [--version <case version>] | --component-set-config <URI> )

Flags:
    -c, --component-set-config URI  A URI that points to a file containing a ComponentSetConfig. Acceptable URI examples:
                                    file:///path/to/file/component-set-config.yaml
                                    file://localhost/path/to/file/component-set-config.yaml
                                    http://host:port/path/to/file/component-set-config.yaml
                                    https://host:port/path/to/file/component-set-config.yaml

      --insecure                    skip TLS/SSL verification (optional)
      --skip-dependencies           skip downloading dependencies (optional)
      --skip-verify                 if provided, skips the certification verification (optional)
      --version string              the "semantic version range" specifying the CASE to download, e.g. '2.0.0' or '>=1.0.0, <=3.0.0' (optional - assumes latest if not provided)
      -h, --help                    help for get

Environment Variables:
    IBMPAK_RESOLVE_DEPENDENCIES     when set to false, no CASE references will be resolved (default "true")
    IBMPAK_HTTP_TIMEOUT             Overrides the default HTTP timeout value used in client calls to external servers. Measured in seconds (default "20")
    IBMPAK_HTTP_RETRY               Maximum http retry attempts, for example when a timeout is encountered on slow networks (default "3")
    HTTPS_PROXY or https_proxy      the URL of a HTTPS proxy (e.g. https://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
    HTTP_PROXY or http_proxy        the URL of a HTTP proxy (e.g. http://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
```

Example: 
```
1) Download a CASE from a repository like github, oci-compliant registry
oc ibm-pak get ibm-my-cloudpak --version 1.0.0

2) Download a set of components referred by a ComponentSetConfig file (with v1.4.0 and later)
oc ibm-pak get -c file:///root/component-set-config.yaml
```

# oc ibm-pak generate mirror-manifests
Generate mirror manifests for a CASE

Usage:
```
oc ibm-pak generate mirror-manifests <case name> <target-registry> --version <case version> --filter <list of groups> [--final-registry <final-registry>] 

Flags:
      --dry-run                    If option provided, leave the merged FBC content in staging directory (optional)
      --filter string              comma separated list of values, which can either be a group name or architecture (default "")
      --final-max-components int   The maximum number of path components allowed in a final registry mapping (0: all paths used, 1: error - not allowed, 2 and more: paths compressed from right to left to honor # provided) (optional)
      --final-registry string      if the target registry is a filesystem (has a "file://" prefix), then this argument must be provided to generate proper ICSP and Catalog Sources,
                                   if the target registry is a registry server, then this argument can be provided optionally to enable mirroring to an intermediate registry followed by mirroring to a final registry specified by this argument (default "")
  -h, --help                       help for mirror-manifests
      --insecure                   skip TLS/SSL verification (optional)
      --max-components int         The maximum number of path components allowed in a target registry mapping (0: all paths used, 1: error - not allowed, 2 and more: paths compressed from right to left to honor # provided) (optional)
      --max-icsp-size int          The maximum number of bytes for the generated ICSP yaml(s) when using --max-components. Defaults to 250000 (default 250000)
      --version string             the exact "case version" already downloaded by "oc ibm-pak get" (optional - assumes latest if not provided)
Global Flags:
      --log_file string   If non-empty, use this log file
  -v, --v Level           number for the log level verbosity [0 (normal), 1 (fine), 2 (finer) or 3 (finest)]
```

Example:
```
1) Generate mirror manifests for a target registry
oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0

2) Generate mirror manifests for a target directory structure that can be served as a registry
oc ibm-pak generate mirror-manifests ibm-my-cloudpak file://myrepository --version 1.0.0 --final-registry myregistry.com

3) Generate mirror manifests for mirroring images to an intermediate registry server and from that server to a final registry server specified via final-registry argument. This creates images-mapping-to-registry.txt and images-mapping-from-registry.txt. Both of these files should used as input to `oc image mirrorr`. When images-mapping-to-registry.txt is used, it will enable mirroring the images to intermediate-registry.com. When images-mapping-from-registry.txt. is used, it will enable mirroring images from intermediate-registry.com to myregistry.com
oc ibm-pak generate mirror-manifests ibm-my-cloudpak intermediate-registry.com --version 1.0.0 --final-registry myregistry.com

4) Generate mirror manifests for an insecure target registry
oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --insecure

5) Generate mirror manifests metadata in staging directory for FBC CASE
oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --dry-run

6) Generate mirror manifests for a target registry where path is compressed to --max-components value. (with v1.9.0 and later)
Max-components:
- value of 0 or not called - default (nothing changes, all paths structure us used)
- value of 1 - error (value not allowed)
- value of 2 or more - paths compressed from right to left to honor # provided
oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --max-components 2

7) Generate mirror manifests for mirroring images to an intermediate registry server and from that server to a final registry server specified via final-registry argument. This creates images-mapping-to-registry.txt and images-mapping-from-registry.txt where intermediate registry paths are compressed to satisfy the value of --max-compoenents and final registry paths are compressed to --final-max-components value. If final-max-compoents is set to default or final-max-components > max-components, final-max-compoents is set to max-components value. (with v1.9.0 and later)
oc ibm-pak generate mirror-manifests ibm-my-cloudpak intermediate-registry.com --version 1.0.0 --final-registry myregistry.com --max-components 3 --final-max-components 2

8) Generate mirror manifests for a target registry where path is compressed to --max-components value and ICSP is generated with sharding as per the --max-icsp-size value. (with v1.9.0 and later)
oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --max-components 2 --max-icsp-size 10000
```

Starting from `v1.9.0`, path compression can be used to install Cloud Paks into target registries with a restricted repository hierarchy . For more information on compression and sharding generated ICSP files, please refer here [documentation on compression and sharding registry paths](compression-sharding.md).

# oc ibm-pak describe
Describe command prints image lists, dependencies, registries and other information for this CASE

Usage:
```
oc ibm-pak describe <case-name> --version <version> (--list-mirror-images)

Flags:
    --version string       "case version" (required)
    --list-mirror-images   list images from generated mirror manifests (required if --list-case-images is not used)
    -o, --output string    Specify output format as json, yaml or ""
    -h, --help             help for describe
```

Example:
```
List mirror images:
oc ibm-pak describe ibm-my-cloudpak --version 1.0.0 --list-mirror-images
```

# oc ibm-pak generate online-manifests
Generate online manifests for a CASE (with v1.8.0 and later)
Usage:
```
oc ibm-pak generate online-manifests <case name> --version <case version>

Flags:
    --version string   the exact "case version" already downloaded by "oc ibm-pak get" (optional - assumes latest if not provided)
    -h, --help         help for online-manifests
```

Example:
```
oc ibm-pak generate online-manifests ibm-my-cloudpak --version 1.0.0
```

# oc ibm-pak launch
Launch a CASE into the targeted cluster.

Usage:
```
oc ibm-pak launch <case name> --version <case version> [flags]

Flags:
    -a, --action string      the name of the action item launched
    -r, --args string        other arguments
        --dry-run            if provided, the location of the main-launch.sh script will be printed instead of executing the script
        --insecure           skip TLS/SSL verification (optional)
    -i, --instance string    the name of the instance of the target application (release)
    -e, --inventory string   the name of the inventory item launched
    -n, --namespace string   the name of the target namespace
        --verify             if provided, additionally verifies the CASE before launching
        --version string     the version of the CASE
    -h, --help               help for launch

Environment Variables:
    IBMPAK_TOLERANCE_RETRY              when set to false, launch script execution failure will not be retried
                                        when set to true, launch script execution failures will be retried without the --tolerance flag (default "true")
    IBMPAK_LAUNCH_SKIP_PREREQ_CHECK     when set to true, will skip checking prerequisites in the launch framework (default "false")
    IBMPAK_HTTP_TIMEOUT                 Overrides the default HTTP timeout value used in client calls to external servers. Measured in seconds (default "10")
```

Example:
```
1) Install catalog
oc ibm-pak launch \
ibm-my-cloudpak \
  --version 1.0.0 \
  --action install-catalog \
  --inventory ibmMyCloudpakOperatorSetup \
  --namespace my-namespace \
  --args "--registry myregistry.com --recursive --inputDir ~/.ibm-pak/data/cases/ibm-my-cloudpak/1.0.0"

2) Install operator
oc ibm-pak launch \
ibm-my-cloudpak \
  --version 1.0.0 \
  --action install-operator \
  --inventory ibmMyCloudpakOperatorSetup \
  --namespace my-namespace
```

# oc ibm-pak list
List CASEs available in the enabled repository or downloaded into the local directory by get command

Usage:
```
oc ibm-pak list

Flags:
        --case-name string   print the list of all CASE images (separately printed for each version) matching the given case name
        --downloaded         print the list of downloaded CASE images available locally
    -o, --output string      Specify output format as json, yaml or ""
    -h, --help               help for list
```

Example:
```
1) List all cases (available in the enabled repository)
oc ibm-pak list

2) List all cases in json output
oc ibm-pak list -o json

3) List downloaded cases (lists the cases which were provided in the command line during `oc ibm-pak get` command)
Note : It doesn’t list any dependent cases downloaded during the `oc ibm-pak get` command.
oc ibm-pak list --downloaded

4) List downloaded cases in yaml output
oc ibm-pak list --downloaded -o yaml

5) List all versions of case
oc ibm-pak list --case-name ibm-my-cloudpak

6) List all versions of case in json output
oc ibm-pak list --case-name ibm-my-cloudpak -o json

7) List downloaded versions of case
oc ibm-pak list --case-name ibm-my-cloudpak --downloaded

8) List downloaded versions of case in yaml output
oc ibm-pak list --case-name ibm-my-cloudpak --downloaded -o yaml
```

# oc ibm-pak verify
Verify the integrity of downloaded CASEs

Usage:
```
oc ibm-pak verify [<case-name> [--version <version>]]

Flags:
  -h, --help             help for verify
  -o, --output string    Specify output format as json, yaml or ""
      --version string   CASE version
Global Flags:
      --log_file string   If non-empty, use this log file
  -v, --v Level           number for the log level verbosity [0 (normal), 1 (fine), 2 (finer) or 3 (finest)]
```
Examples:

```
1)Verify the integrity of all the downloaded CASEs
oc ibm-pak verify

2)Verify the integrity of all the downloaded versions of a CASE
oc ibm-pak verify ibm-cp-common-services

3)Verify the integrity of a specific version of a downloaded CASE
oc ibm-pak verify ibm-cp-common-services --version 1.19.3
```