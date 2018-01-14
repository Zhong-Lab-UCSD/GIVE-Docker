# GIVE-Docker
GIVE-Docker is a Docker image for _**GIVE (Genomic Interactive Visualization Engine)**_. Please check [GIVE homepage]](give.genemo.org) and [GIVE GitHub Repo](https://github.com/Zhong-Lab-UCSD/Genomic-Interactive-Visualization-Engine) for more information about GIVE. This repo is a part of GIVE project. Here we proovide Dockfile, scripts and data for building GIVE-Docker. Users familiar with Docker can build their own version of GIVE Docker image.

## Description of GIVE-Docker
### Base Iamge
The GIVE-Docker image is built on a base LAMP image, [linode/lamp](https://hub.docker.com/r/linode/lamp/). The linode/lamp supplied LAMP environment (**L**inux, **A**pache, **M**ySQL and **P**HP) in Ubuntu 14.04. We configured Apache2, MySQL and PHP for GIVE in GIVE-Docker. Besides, we added pre-built data of a demo genome browser in GIVE-Docker. 

### Software and Configuration
All the configurations can be tracked in the `Dockerfile` and `setgive_script.h`. Here, we briefly introducing the main changes.
#### Apache2
- ssl, include, headers, and cgi modules are enabled. 
- The example.com site is disabled and removed. 
- Copy pre-defined `001-give` and `001-give-ssl` config files into `/etc/apache2/sites-avaliable`. And enable these sites.
#### PHP
- Install php5-mysqlnd for communication between php and MySQL.
#### GIVE Components
- The latest version of GIVE components are set in `/var/www/give` folder. In this repo, the GIVE repo is added as a submodule. 
- Copy `constants.js` into `/var/www/give/html/components/bower_components/genemo-data-components/basic-func/` folder. Copy `constants.php` into `/var/www/give/includes/` folder. These pre-built files will set some constant parameters related to PHP-MySQL communication.
- Copy a pre-built `index.html` file into `/var/www/give/html/`. It's a demo genome browser.
#### MySQL
We added a [demo genome browser](https://github.com/Zhong-Lab-UCSD/Genomic-Interactive-Visualization-Engine/tree/master/gallery/Demo2-ENCODE2_ChIA-PET) into MySQL database.
- Create `compbrowser` and `hg19` database. Then, load pre-built data into these two databases.
## Usage of GIVE-Docker
The usage of GIVE can be found in [GIVE Tutorial 3: Easy local deployment of GIVE with GIVE-Docker](https://github.com/Zhong-Lab-UCSD/Genomic-Interactive-Visualization-Engine/blob/master/tutorials/GIVE-Docker.md)

## Credits

GIVE-Docker is a part of GIVE project. GIVE is developed by Xiaoyi Cao, Zhangming Yan, Qiuyang Wu, Alvin Zheng from Dr. Sheng Zhong's lab at University of California, San Diego.

## License

Copyright 2017 GIVe Authors

This project is licensed under the Apache License, Version 2.0 (the "License");
you may not use this project except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
