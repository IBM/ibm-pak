<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [ibm-pak help](#ibm-pak-help)
- [ibm-pak config repo](#ibm-pak-config-repo)
- [ibm-pak config locale](#ibm-pak-config-locale)
- [ibm-pak config color](#ibm-pak-config-color)
- [ibm-pak config mirror-tools](#ibm-pak-config-mirror-tools)
- [ibm-pak config mirror-tools oc-image-mirror](#ibm-pak-config-mirror-tools-oc-image-mirror)
- [ibm-pak config mirror-tools oc-mirror](#ibm-pak-config-mirror-tools-oc-mirror)
- [ibm-pak config catalog-builder](#ibm-pak-config-catalog-builder)
- [ibm-pak config](#ibm-pak-config)
- [ibm-pak get](#ibm-pak-get)
- [ibm-pak generate mirror-manifests](#ibm-pak-generate-mirror-manifests)
- [ibm-pak describe](#ibm-pak-describe)
- [ibm-pak generate online-manifests](#ibm-pak-generate-online-manifests)
- [ibm-pak launch](#ibm-pak-launch)
- [ibm-pak list](#ibm-pak-list)
- [ibm-pak verify](#ibm-pak-verify)

# ibm-pak help
Deploy IBM Cloud Paks in a disconnected environment or generate image mirror manifest files

Usage:
```
oc ibm-pak --help

Available Commands:
  config      Displays changes to configuration file used by this plugin
  describe    Describe command prints image lists, dependencies, registries and other information for this CASE
  generate    Generate command
  get         Download a CASE or a set of components referred by a ComponentSetConfig file from a repository like github, oci-compliant registry etc
  help        Help about any command
  launch      Launch a CASE into the targeted cluster.
  list        List CASEs available in the enabled repository or downloaded into the local directory by get command
  verify      Verify the integrity of downloaded CASEs

Flags:
  -h, --help              help for ibm-pak
      --insecure          skip TLS/SSL verification (optional)
      --log_file string   If non-empty, use this log file
  -v, --v int             number for the log level verbosity [0 (normal), 1 (fine), 2 (finer) or 3 (finest)]
      --version           print version (optional)
Use "oc ibm-pak [command] --help" for more information about a command.

Environment Variables:
  IBMPAK_HOME                     the directory under which the plugin will create .ibm-pak directory to store the plugin command execution results
                                   in specific folders like config, data etc (default "user's home directory")
  IBMPAK_TOLERANCE_RETRY          when set to false, launch script execution failure will not be retried
                                  when set to true, launch script execution failures will be retried without the --tolerance flag (default "true")
  IBMPAK_RESOLVE_DEPENDENCIES     when set to false, no CASE references will be resolved (default "true")
  IBMPAK_LAUNCH_SKIP_PREREQ_CHECK when set to true, will skip checking prerequisites in the launch framework (default "false")
  IBMPAK_HTTP_TIMEOUT             Overrides the default HTTP timeout value used in client calls to external servers. Measured in seconds (default "20")
  IBMPAK_HTTP_RETRY               Maximum http retry attempts, for example when a timeout is encountered on slow networks (default "3")
  HTTPS_PROXY or https_proxy      the URL of a HTTPS proxy (e.g. https://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
  HTTP_PROXY or http_proxy        the URL of a HTTP proxy (e.g. http://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
  NO_COLOR                        when present and not an empty string (regardless of its value) disables colored text output (default "")
```
# ibm-pak config repo
Configure the plug-in to download CASEs from the raw github url or as OCI artifacts from IBM Cloud Container Registry (ICR).

Usage:
```
oc ibm-pak config repo <repository name> [--url=<raw github url|oci registry url>] [--delete|--enable]

Flags:
  -d, --delete                 deletes the repository with the <repository name> argument (optional)
  -e, --enable                 Marks the repository with the <repository name> argument to be selected for downloading a CASE. Only one repo can be configured to be enabled (optional)
  -h, --help                   help for repo
  -r, --url "raw github url"   "raw github url" for a CASE repository (default "https://github.com/IBM/cloud-pak/raw/master/repo/case/")

Global Flags:
      --insecure          skip TLS/SSL verification (optional)
      --log_file string   If non-empty, use this log file
  -v, --v int             number for the log level verbosity [0 (normal), 1 (fine), 2 (finer) or 3 (finest)]
```

Example:
- Add a repository with default url (`https://github.com/IBM/cloud-pak/raw/master/repo/case/`)
  ```
  oc ibm-pak config repo 'IBM Cloud-Pak Github Repo'
  ```

- Add/Update a repository
  ```
  oc ibm-pak config repo 'IBM Cloud-Pak OCI registry' --url oci:cp.icr.io/cpopen
  ```

- Remove a repository
  ```
  oc ibm-pak config repo 'IBM Cloud-Pak OCI registry' --delete
  ```

- Enable a repository
  ```
  oc ibm-pak config repo 'IBM Cloud-Pak Github Repo'  --enable

  OR

  oc ibm-pak config repo 'IBM Cloud-Pak Github Repo' --url https://github.com/IBM/cloud-pak/raw/master/repo/case/ --enable
  ```

# ibm-pak config locale
Configure locale for plug-in.

Usage:
```
oc ibm-pak config locale --language=<language>

Flags:
  -h, --help              help for locale
  -l, --language string   Set default language, an empty value will trigger an auto detection of the language
```

Example: 
- Update Locale
  ```
  oc ibm-pak config locale -l fr_FR
  ```

- Reset locale to default, system detects the locale to use
  ```
  oc ibm-pak config locale -l ""
  ```

# ibm-pak config color
Enable/disable color output (Supported with ibm-pak version `v1.4.0` or higher)

Usage:
```
oc ibm-pak config color --enable <true|false>

Flags:
  -e, --enable string   Enable coloring the plugin's command output in the console
  -h, --help            help for color
```

Example:
- Enable color output
  ```
  oc ibm-pak config color --enable true
  ```

- Disable color output
  ```
  oc ibm-pak config color --enable false
  ```

# ibm-pak config mirror-tools
Configure the mirror-tools (Supported with ibm-pak version `v1.8.0` or higher)

Usage:
```
oc ibm-pak config mirror-tools --enabled <oc-image-mirror|oc-mirror>

Flags:
  -e, --enabled string   Set the enabled tool to be used from the following list: oc-image-mirror, oc-mirror (default "oc-image-mirror")
  -h, --help             help for mirror-tools
```

Example: 
- Enable oc image mirror tool
  ```
  oc ibm-pak config mirror-tools --enabled oc-image-mirror
  ```

- Enable oc mirror tool
  ```
  oc ibm-pak config mirror-tools --enabled oc-mirror
  ```

# ibm-pak config mirror-tools oc-image-mirror
Configure the oc-image-mirror tool settings (Supported with ibm-pak version `v1.8.0` or higher)

Usage:
```
oc ibm-pak config mirror-tools oc-image-mirror < --connected-flags|--disconnected-target-flags|--disconnected-final-flags > <flags>

Flags:
      --connected-flags string             Set the connected mirroring flags for configuring the oc image mirror tool in connected mode (Setting this flag as AUTO_GENERATE will make the plugin use --filter-by-os '.*' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1) (default "AUTO_GENERATE")
      
      --disconnected-final-flags string    Set the disconnected mirroring to final flags for configuring the oc image mirror tool to final registry in disconnected mode (Setting this flag as AUTO_GENERATE will make the plugin use --filter-by-os '.*' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --from-dir "$IMAGE_PATH") (default "AUTO_GENERATE")
      
      --disconnected-target-flags string   Set the disconnected mirroring to target flags for configuring the oc image mirror tool to target filesystem or registry in disconnected mode (Setting this flag as AUTO_GENERATE will make the plugin use --filter-by-os '.*' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --dir "$IMAGE_PATH") (default "AUTO_GENERATE")
  
  -h, --help                               help for oc-image-mirror
```

Example: 

- Update connected-flags
  ```
  oc ibm-pak config mirror-tools oc-image-mirror --connected-flags '--filter-by-os '\''.*'\'' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1'
  ```

- Reset connected-flags to AUTO_GENERATE (to reset flag value to default value)
  ```
  oc ibm-pak config mirror-tools oc-image-mirror --connected-flags AUTO_GENERATE
  ```

- Update disconnected-target-flags
  ```
  oc ibm-pak config mirror-tools oc-image-mirror --disconnected-target-flags '--filter-by-os '\''.*'\'' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --dir "$IMAGE_PATH"'
  ```

- Update disconnected-final-flags
  ```
  oc ibm-pak config mirror-tools oc-image-mirror --disconnected-final-flags '--filter-by-os '\''.*'\'' -a $REGISTRY_AUTH_FILE --insecure --skip-multiple-scopes --max-per-registry=1 --from-dir "$IMAGE_PATH"'
  ```

# ibm-pak config mirror-tools oc-mirror
Configure the oc-mirror tool settings (Supported with ibm-pak version `v1.8.0` or higher)

Usage:
```
oc ibm-pak config mirror-tools oc-mirror --storage=<storage> [--storage-skip-tls] --target-catalog=<target-catalog> --target-tag=<target-tag> < --connected-flags|--disconnected-target-flags|--disconnected-final-flags > <flags>

Flags:
      --connected-flags string             Set the connected mirroring flags for configuring the oc mirror tool in connected mode (Setting this flag as AUTO_GENERATE will make the plugin use --dest-skip-tls --max-per-registry=6) (default "AUTO_GENERATE")
      
      --disconnected-final-flags string    Set the disconnected mirroring to final flags for configuring the oc mirror tool to final registry in disconnected mode (Setting this flag as AUTO_GENERATE will make the plugin use --dest-skip-tls --from=sequence_file.tar) (default "AUTO_GENERATE")
      
      --disconnected-target-flags string   Set the disconnected mirroring to target flags for configuring the oc mirror tool to target filesystem or registry in disconnected mode (Setting this flag as AUTO_GENERATE will make the plugin use --dest-skip-tls --max-per-registry=6) (default "AUTO_GENERATE")
  
  -h, --help                               help for oc-mirror
  
  -s, --storage string                     Set the storage via a file or a docker reference
  
      --storage-skip-tls                   Disable TLS verification when using a registry server as storage (applies only to docker registry)
  
      --target-catalog string              Set the target catalog (including registry path) (default "ibm-catalog")
  
      --target-tag string                  Set the target catalog tag (Setting this flag as AUTO_GENERATE will make the plugin generate target tag dynamically) (default "AUTO_GENERATE")
```

Example: 
- Configure a local path based storage 
  ```
  oc ibm-pak config mirror-tools oc-mirror --storage file:///tmp/local-backed
  ```

- Configure a registry based storage for oc-mirror
  ```
  oc ibm-pak config mirror-tools oc-mirror --storage docker://quay.io/foo/bar:example
  ```

- Configure a registry based storage for oc-mirror allowing insecure connections 
  ```
  oc ibm-pak config mirror-tools oc-mirror --storage docker://quay.io/foo/bar:example --storage-skip-tls
  ```

- Configure a target catalog and target tag
  ```
  oc ibm-pak config mirror-tools oc-mirror --target-catalog ibm-catalog --target-tag latest
  ```

- Update connected-flags
  ```
  oc ibm-pak config mirror-tools oc-mirror --connected-flags '--dest-skip-tls --max-per-registry=6'
  ```

- Reset connected-flags to AUTO_GENERATE
  ```
  oc ibm-pak config mirror-tools oc-mirror --connected-flags AUTO_GENERATE
  ```

- Update disconnected-target-flags
  ```
  oc ibm-pak config mirror-tools oc-mirror --disconnected-target-flags '--dest-skip-tls --max-per-registry=6'
  ```

- Update disconnected-final-flags
  ```
  oc ibm-pak config mirror-tools oc-mirror --disconnected-final-flags '--dest-skip-tls --from=sequence_file.tar'
  ```

# ibm-pak config catalog-builder
Configures the catalog-builder settings (Supported with ibm-pak version `v1.8.0` or higher)

Usage:
```
oc ibm-pak config catalog-builder --base-image myregistry.com/images/base-image:1.0

Flags:
      --base-image string   Set the base image for fbc catalog (Setting this flag as AUTO_GENERATE will make the plugin use icr.io/cpopen/ibm-operator-catalog:fbc-base-latest) (default "AUTO_GENERATE")
  -h, --help                help for catalog-builder
```

Example:
- Configure a catalog base image used during curation
  ```
  oc ibm-pak config catalog-builder --base-image icr.io/cpopen/ibm-operator-catalog:fbc-base-latest
  ```

- Reset catalog base image to AUTO_GENERATE
  ```
  oc ibm-pak config catalog-builder --base-image AUTO_GENERATE
  ```

# ibm-pak config
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
Local storage config (for v1 only):
  Path: /root/.ibm-pak/oc-mirror-storage

Connected Mirroring Flags:
  AUTO_GENERATE (v1 : --dest-skip-tls --max-per-registry=6 , v2 : --dest-tls-verify=false)

Disconnected Mirroring Flags:
  To Target FileSystem or Registry:
    AUTO_GENERATE (v1 : --dest-skip-tls --max-per-registry=6 , v2 : )

  To Final Registry:
    AUTO_GENERATE (v1 : --dest-skip-tls , v2 : --dest-tls-verify=false)

Target catalog: ibm-catalog

Target tag: AUTO_GENERATE


Enabled tool: oc image mirror

Catalog Builder Config

Base image: AUTO_GENERATE (icr.io/cpopen/ibm-operator-catalog:fbc-base-latest)

```

# ibm-pak get
Download a CASE or a set of components referred by a ComponentSetConfig file from a repository like github, oci-compliant registry etc.

Usage:
```
oc ibm-pak get ( <CASE-NAME> [--version <CASE-VERSION>] | --component-set-config <URI> )

Flags:
  -c, --component-set-config URI   A URI that points to a file containing a ComponentSetConfig. Acceptable URI examples:
                                   file:///path/to/file/component-set-config.yaml
                                   file://localhost/path/to/file/component-set-config.yaml
                                   http://host:port/path/to/file/component-set-config.yaml
                                   https://host:port/path/to/file/component-set-config.yaml
                                   
  -h, --help                       help for get
      --install-method string      Install method to generate manifests as per install type. One of: [OLM, helm] (default "OLM")
      --skip-dependencies          skip downloading dependencies (optional)
      --skip-verify                if provided, skips the certification verification (optional)
      --version string             the "semantic version range" specifying the CASE to download, e.g. '2.0.0' or '>=1.0.0, <=3.0.0' (optional - assumes latest if not provided)

Environment Variables:
  IBMPAK_RESOLVE_DEPENDENCIES when set to false, no CASE references will be resolved (default "true")
  IBMPAK_HTTP_TIMEOUT         Overrides the default HTTP timeout value used in client calls to external servers. Measured in seconds (default "20")
  IBMPAK_HTTP_RETRY           Maximum http retry attempts, for example when a timeout is encountered on slow networks (default "3")
  HTTPS_PROXY or https_proxy  the URL of a HTTPS proxy (e.g. https://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
  HTTP_PROXY or http_proxy    the URL of a HTTP proxy (e.g. http://[user]:[pass]@[proxy_ip]:[proxy_port]) (default "")
```

Example: 
- Download a CASE from a repository like github, oci-compliant registry
  ```
  oc ibm-pak get ibm-my-cloudpak --version 1.0.0
  ```

- Download a set of components referred by a ComponentSetConfig file (Supported with ibm-pak version `v1.4.0` or higher)
  ```
  oc ibm-pak get -c file:///root/component-set-config.yaml
  ```

- Download a CASE without resolving dependencies
  ```
  oc ibm-pak get ibm-my-cloudpak --version 1.0.0 --skip-dependencies
  ```
  
- Download a CASE for `OLM` install method (Supported with ibm-pak version `v1.18.0` or higher)
  ```
  oc ibm-pak get ibm-my-cloudpak --version 1.0.0 --install-method OLM
  ```

- Download a CASE for `helm` install method (Supported with ibm-pak version `v1.18.0` or higher)
  ```
  oc ibm-pak get ibm-my-cloudpak --version 1.0.0 --install-method helm
  ```

# ibm-pak generate mirror-manifests
Generate mirror manifests for a CASE

Usage:
```
oc ibm-pak generate mirror-manifests <CASE-NAME> <target-registry> --version <CASE-VERSION> --filter <list of groups> [--final-registry <final-registry>] 

Flags:
      --authfile string            Auth file path to override default location to pull catalog from registry requiring authentication (optional)
      --dry-run                    If option provided, leave the merged FBC content in staging directory (optional)
      --enable-restricted-scc      if provided, generates catalog sources with restricted securityContextConfig (optional)
      --filter string              comma separated list of values, which can either be a group name or architecture (default "")
      --final-max-components int   The maximum number of path components allowed in a final registry mapping (0: all paths used, 1: error - not allowed, 2 and more: paths compressed from right to left to honor # provided) (optional)
      --final-registry string      if the target registry is a filesystem (has a "file://" prefix), then this argument must be provided to generate proper ICSP and Catalog Sources,
                                   if the target registry is a registry server, then this argument can be provided optionally to enable mirroring to an intermediate registry followed by mirroring to a final registry specified by this argument (default "")
  -h, --help                       help for mirror-manifests
      --install-method string      Install method to generate manifests as per install type. One of: [OLM, helm] (default "OLM")
      --max-components int         The maximum number of path components allowed in a target registry mapping (0: all paths used, 1: error - not allowed, 2 and more: paths compressed from right to left to honor # provided) (optional)
      --max-icsp-size int          The maximum number of bytes for the generated ICSP yaml(s) when using --max-components. Defaults to 250000 (default 250000)
      --max-idms-size int          The maximum number of bytes for the generated IDMS yaml(s) when using --max-components. Defaults to 250000 (default 250000)
      --oc-mirror-plugin string    oc-mirror plugin to generate manifests as per plugin type. One of: [v1, v2] (default "v1")
      --version string             the exact "case version" already downloaded by "oc ibm-pak get" (optional - assumes latest if not provided)
```

Example:
- Generate mirror manifests for a target registry (Connected mirroring)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0
  ```

- Generate mirror manifests for a target directory structure that can be served as a registry (Disconnected mirroring)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak file://myrepository --version 1.0.0 --final-registry myregistry.com
  ```

- Generate mirror manifests for mirroring images to an intermediate registry and from that registry to a final registry specified via `final-registry` argument. This creates `images-mapping-to-registry.txt` and `images-mapping-from-registry.txt`. Both of these files should used as input to `oc image mirror` command.
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak intermediate-registry.com --version 1.0.0 --final-registry myregistry.com
  ```

- Generate mirror manifests with image filtering by group
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --filter imageGroup1,imageGroup2
  ```

- Generate mirror manifests for an insecure target registry
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --insecure
  ```

- Generate mirror manifests metadata in staging directory for FBC CASE (Supported with ibm-pak version `v1.8.0` or higher)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --dry-run
  ```

- **Note:** Starting from `v1.9.0`, path compression can be used to install Cloud Paks into target registries with a restricted repository hierarchy . For more information on compression and sharding generated ICSP files, please refer here [documentation on compression and sharding registry paths](compression-sharding.md).

- Generate mirror manifests for a target registry where path is compressed to `--max-components` value. (Supported with ibm-pak version `v1.9.0` or higher)
  - Max-components:
    - value of 0 or not called - default (nothing changes, all paths structure us used)
    - value of 1 - error (value not allowed)
    - value of 2 or more - paths compressed from right to left
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --max-components 2
  ```
- Generate mirror manifests for mirroring images to an intermediate registry to a final registry. Where intermediate registry paths are compressed to satisfy the value of `--max-compoenents` and final registry paths are compressed to `--final-max-components` value. If `final-max-compoents` is set to default or `final-max-components` > `max-components`, `final-max-compoents` is set to `max-components` value. (Supported with ibm-pak version `v1.9.0` or higher)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak intermediate-registry.com --version 1.0.0 --final-registry myregistry.com --max-components 3 --final-max-components 2
  ```

- Generate mirror manifests for a target registry where path is compressed to `--max-components` value and ICSP is generated with sharding as per the `--max-icsp-size` value. (Supported with ibm-pak version `v1.9.0` or higher)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --max-components 2 --max-icsp-size 10000
  ```

- Generate mirror manifests for a target registry where path is compressed to `--max-components` value and IDMS is generated with sharding as per the `--max-idms-size` value. (Supported with ibm-pak version `v1.12.0` or higher)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --max-components 2 --max-idms-size 10000
  ```

- Generate mirror manifests with `restricted` securityContextConfig in generated catalog sources (Supported with ibm-pak version `v1.16.0` or higher)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --enable-restricted-scc
  ```

- Generate mirror manifests for `OLM` install method (Supported with ibm-pak version `v1.18.0` or higher)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --install-method OLM
  ``` 

- Generate mirror manifests for `helm` install method (Supported with ibm-pak version `v1.18.0` or higher)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --install-method helm
  ```

- Generate mirror manifests for `oc-mirror v2` (Supported with ibm-pak version `v1.19.0` or higher)
  ```
  oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0 --oc-mirror-plugin v2
  ```  

# ibm-pak describe
Describe command prints image lists, dependencies, registries and other information for this CASE

Usage:
```
oc ibm-pak describe <CASE-NAME> --version <version> (--list-mirror-images)

Flags:
  -h, --help                 help for describe
      --list-case-images     [Deprecated] list images from downloaded CASE (required if --list-mirror-images is not used)
      --list-mirror-images   list images from generated mirror manifests (required if --list-case-images is not used)
  -o, --output string        Specify output format as json, yaml or ""
      --version string       "case version" (required)
```

Example:
- List mirror images:
  ```
  oc ibm-pak describe ibm-my-cloudpak --version 1.0.0 --list-mirror-images
  ```

# ibm-pak generate online-manifests
Generate online manifests for a CASE (Supported with ibm-pak version `v1.8.0` or higher)

Usage:
```
oc ibm-pak generate online-manifests <CASE-NAME> --version <CASE-VERSION>

Flags:
      --authfile string         Auth file path to override default location to pull catalog from registry requiring authentication (optional)
      --enable-restricted-scc   if provided, generates catalog sources with restricted securityContextConfig (optional)
  -h, --help                    help for online-manifests
      --install-method string   Install method to generate manifests as per install type. One of: [OLM, helm] (default "OLM")
      --version string          the exact "case version" already downloaded by "oc ibm-pak get" (optional - assumes latest if not provided)
```

Example:
- Generate online manifests
  ```
  oc ibm-pak generate online-manifests ibm-my-cloudpak --version 1.0.0
  ```

- Generate online manifests with `restricted` securityContextConfig in generated catalog sources (Supported with ibm-pak version `v1.16.0` or higher)
  ```
  oc ibm-pak generate online-manifests ibm-my-cloudpak --version 1.0.0 --enable-restricted-scc
  ```

- Generate online manifests for `OLM` install method (Supported with ibm-pak version `v1.18.0` or higher)
  ```
  oc ibm-pak generate online-manifests ibm-my-cloudpak --version 1.0.0 --install-method OLM
  ``` 

- Generate online manifests for `helm` install method (Supported with ibm-pak version `v1.18.0` or higher)
  ```
  oc ibm-pak generate online-manifests ibm-my-cloudpak --version 1.0.0 --install-method helm
  ```  

# ibm-pak launch
Launch a CASE into the targeted cluster.

Usage:
```
oc ibm-pak launch <CASE-NAME> --version <CASE-VERSION> [flags]

Flags:
  -a, --action string      the name of the action item launched
  -r, --args string        other arguments
      --dry-run            if provided, the location of the main-launch.sh script will be printed instead of executing the script
  -h, --help               help for launch
  -i, --instance string    the name of the instance of the target application (release)
  -e, --inventory string   the name of the inventory item launched
  -n, --namespace string   the name of the target namespace
      --verify             if provided, additionally verifies the CASE before launching
      --version string     the version of the CASE

Environment Variables:
  IBMPAK_TOLERANCE_RETRY          when set to false, launch script execution failure will not be retried
                                  when set to true, launch script execution failures will be retried without the --tolerance flag (default "true")
  IBMPAK_LAUNCH_SKIP_PREREQ_CHECK when set to true, will skip checking prerequisites in the launch framework (default "false")
  IBMPAK_HTTP_TIMEOUT             Overrides the default HTTP timeout value used in client calls to external servers. Measured in seconds (default "20")
  IBMPAK_HTTP_RETRY               Maximum http retry attempts, for example when a timeout is encountered on slow networks (default "3")
```

Example:
- Install catalog
  ```
  oc ibm-pak launch \
  ibm-my-cloudpak \
    --version 1.0.0 \
    --action install-catalog \
    --inventory ibmMyCloudpakOperatorSetup \
    --namespace my-namespace \
    --args "--registry myregistry.com --recursive --inputDir ~/.ibm-pak/data/cases/ibm-my-cloudpak/1.0.0"
  ```

- Install operator
  ```
  oc ibm-pak launch \
  ibm-my-cloudpak \
    --version 1.0.0 \
    --action install-operator \
    --inventory ibmMyCloudpakOperatorSetup \
    --namespace my-namespace
  ```

# ibm-pak list
List CASEs available in the enabled repository or downloaded into the local directory by get command

Usage:
```
oc ibm-pak list

Flags:
      --case-name string   print the list of all CASE images (separately printed for each version) matching the given case name
      --downloaded         print the list of downloaded CASE images available locally
  -h, --help               help for list
  -o, --output string      Specify output format as json, yaml or ""
```

Example:
- List all CASEs (available in the enabled repository)
  ```
  oc ibm-pak list
  ```

- List all CASEs in json output
  ```
  oc ibm-pak list -o json
  ```

- List downloaded CASEs (lists CASEs which were provided in the command line during `oc ibm-pak get` command)

  **Note:** It doesn’t list any dependent CASEs downloaded during the `oc ibm-pak get` command.
  ```
  oc ibm-pak list --downloaded
  ```

- List downloaded CASEs in yaml output
  ```
  oc ibm-pak list --downloaded -o yaml
  ```

- List all versions of CASE
  ```
  oc ibm-pak list --case-name ibm-my-cloudpak
  ```

- List all versions of CASE in json output
  ```
  oc ibm-pak list --case-name ibm-my-cloudpak -o json
  ```

- List downloaded versions of CASE
  ```
  oc ibm-pak list --case-name ibm-my-cloudpak --downloaded
  ```

- List downloaded versions of CASE in yaml output
  ```
  oc ibm-pak list --case-name ibm-my-cloudpak --downloaded -o yaml
  ```

# ibm-pak verify
Verify the integrity of downloaded CASEs

Usage:
```
oc ibm-pak verify [<CASE-NAME> [--version <version>]]

Flags:
  -h, --help             help for verify
  -o, --output string    Specify output format as json, yaml or ""
      --version string   CASE version
```
Examples:
- Verify the integrity of all downloaded CASEs
  ```
  oc ibm-pak verify
  ```

- Verify the integrity of all downloaded versions of a CASE
  ```
  oc ibm-pak verify ibm-my-cloudpak
  ```

- Verify the integrity of a specific version of a downloaded CASE
  ```
  oc ibm-pak verify ibm-my-cloudpak --version 1.0.0
  ```