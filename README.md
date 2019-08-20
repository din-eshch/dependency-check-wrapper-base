# dependency-check-container-wrapper-base
Dependency Check Container Wrapper Base

Base image with the latest version of Dependency Check and CVEs

### Config:
Common config options are moved to config.ini for low friction. Changes to log file path, report name, when to break the build can be made in the config file.

### Jenkins Job Info:
Run this job for Dependency Check version upgrades only

Any push to this repository will automatically trigger a build in jenkins. This build will push the newly built image into artifactory and overwrite the previous one.

Build alerts will be sent to slack channel: #dc
