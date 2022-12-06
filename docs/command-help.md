<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [oc ibm-pak config repo](#oc-ibm-pak-config-repo)
- [oc ibm-pak config locale](#oc-ibm-pak-config-locale)
- [oc ibm-pak config color](#oc-ibm-pak-config-color)
- [oc ibm-pak config](#oc-ibm-pak-config)
- [oc ibm-pak get](#oc-ibm-pak-get)
- [oc ibm-pak generate mirror-manifests](#oc-ibm-pak-generate-mirror-manifests)
- [oc ibm-pak describe](#oc-ibm-pak-describe)
- [oc ibm-pak launch](#oc-ibm-pak-launch)
- [oc ibm-pak list](#oc-ibm-pak-list)

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

# oc ibm-pak config
To see the existing configuration details for plug-in.

Usage:
```
oc ibm-pak config
```

Example Output : 
```
Repository Config

Name                        CASE Repo URL                                          
----                        -------------                                          
IBM Cloud-Pak Github Repo * https://github.com/IBM/cloud-pak/raw/master/repo/case/ 
IBM Cloud-Pak OCI registry  oci:cp.icr.io/cpopen                                   

Locale Config

Language: en_US

Color Config

Enabled: true
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
    IBMPAK_HTTP_TIMEOUT             Overrides the default HTTP timeout value used in client calls to external servers. Measured in seconds (default "10")
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
    --version string          the exact "case version" already downloaded by "oc ibm-pak get" (optional - assumes latest if not provided)
    --filter string           comma separated list of values, which can either be a group name or architecture (default "")
    --final-registry string   if the provided target registry is a filesystem (has a "file://" prefix), a final registry needs to be provided to 
                              generate proper ICSP and Catalog Sources (default "")
    -h, --help                help for mirror-manifests
```

Example:
```
1) Generate mirror manifests for a target registry
oc ibm-pak generate mirror-manifests ibm-my-cloudpak myregistry.com --version 1.0.0

2) Generate mirror manifests for a target directory structure that can be served as a registry
oc ibm-pak generate mirror-manifests ibm-my-cloudpak file://myrepository --version 1.0.0 --final-registry myregistry.com
```

# oc ibm-pak describe
Describe command prints image lists, dependencies, registries and other information for this CASE

Usage:
```
oc ibm-pak describe <case-name> --version <version> (--list-case-images | --list-mirror-images)

Flags:
    --version string       "case version" (required)
    --list-case-images     list images from downloaded CASE (required if --list-mirror-images is not used)
    --list-mirror-images   list images from generated mirror manifests (required if --list-case-images is not used)
    -o, --output string    Specify output format as json, yaml or ""
    -h, --help             help for describe
```

Example:
```
1) List case images
oc ibm-pak describe ibm-my-cloudpak --version 1.0.0 --list-case-images

2) List mirror images
oc ibm-pak describe ibm-my-cloudpak --version 1.0.0 --list-mirror-images
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