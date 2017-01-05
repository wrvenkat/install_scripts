## Description ##
  This repository contains the scripts that are used to install softwares listed in the [ibnr-conf](https://github.com/wrvenkat/ibnr-conf) file. The scripts are called by the install script based on this config file.
  
## Getting Started and Contributing ##
  The scripts in this folder install one software. They may or may not install software from source. A script is the only solution when a simple, add PPA, refresh and install flow does not do the job.
  
#### Conventions and guidelines for creating an install script####
  * An install script that installs software `foo-bar` *should* be named as `foo-bar-install.sh` and a corresponding entry added to the [ibnr-conf](https://github.com/wrvenkat/ibnr-conf) config file.
  * An install script *should* always exit with a value - 0 for no error and 1 for failure. This exit value is used by the install script to determine if the installation was successfuly or not.
  * An install script *should* never leave any background process and should always be blocking. This is because, once an install script exits, bnr's install script looks for an exit value to determine whether the operation was successful or not. Locking any resource or leaving background processes can interfere with other install scripts.
  * An install script *should* carry out all of the steps in installation without any user intervention. (Ex: accepting a license agreement, typing a password). This should be handled by the install script itself as install scripts executed inside a sub-shell and the user can't interact with the running script.
  * All messages output by the install script to STDIN or STDERR is retained by bnr's install script for use in logging. Hence, additional error messages are encouraged and there needn't be any separate logging at the script level.
  
## LICENSE ##

[GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)
