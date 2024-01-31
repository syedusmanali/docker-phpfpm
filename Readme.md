# DOCKER CUSTOM PHP-FPM IMAGE
Custom `PHP-FPM` image with basic `PHP` extensions and custom `PHP` configurations `php.ini`

## Version of Base Image
 * `php:8.1-fpm` customized see [dockerfile] for more details

## Installation or Download
```
$ git clone https://github.com/syedusmanali/docker-phpfpm.git
```

## Configurations
* PHP image can be modified as required eg installation of PHP extensions which can be specified in [dockerfile]. 
See [docker-php-extension-installer] for more details on PHP extensions.
* PHP custom configurations can be provided in [custom_php.ini] or as a separate file inside the [customPHPConf] folder.

## PreBuild image
Pre build image can be downloaded as well if no changes are required in the image see [syedusmanali/php-fpm] for further info.
```
docker pull syedusmanali/php-fpm
``` 
## Building the image
Inside the terminal window go to the base folder of dockerfile by running

```
$ cd [basepath]/docker-phpfpm
```
And to create the image Run 
```
$ docker build .
```
or with docker repository tag/tags
```
$ docker build -t syedusmanali/php-fpm -t syedusmanali/php-fpm:8.1 .
``` 

## Running Container
We will use PHP-FPM with NGINX to serve our PHP app. Doing so will allow us to setup more complex configuration, serve static assets using NGINX.

### Step 1: Create a network

```console
$ docker network create mycustomnetwork
```

or using Docker Compose:

```yaml
version: '3'
networks:
  mycustomnetwork: ~
```

### Step 2: Configure your NGINX server block

Modify your NGINX server block inside [mysite.conf]


### Step 3: Run the PHP-FPM image with a specific name

Docker's linking system uses container ids or names to reference containers. We can explicitly specify a name for our PHP-FPM server to make it easier to connect to other containers.

```console
$ cd [basepath]/docker-phpfpm
```
Note : `-d` flag is to make the container run in background.
```console
$ docker run -d --name phpfpm --network mycustomnetwork -v /path/to/mysite/:/var/www/codebase syedusmanali/php-fpm
```

or using Docker Compose:

```yaml
services:
  phpfpm:
    image: 'syedusmanali/php-fpm'
    networks:
      - mycustomnetwork
    volumes:
      - /path/to/app:/var/www/codebase
```

### Step 4: Run the NGINX image

Note: The command `docker run -v /path/to/dir` does not accept relative paths, you should provide an absolute path that is why we are using `$(pwd)`.
```console
$ docker run -it -v $(pwd)/nginxConf/:/etc/nginx/conf.d/ --network mycustomnetwork -p 80:80 nginx:1.17.0
```

or using Docker Compose:

```yaml
services:
  nginx:
    image: 'nginx:1.17.0'
    depends_on:
      - phpfpm
    networks:
      - mycustomnetwork
    ports:
      - '80:80'
    volumes:
      - ./nginxConf/:/etc/nginx/conf.d/
```
### Access
Now the application should be accessible at `http://localhost`

## Entering the PHP container

```console
$ docker exec -it phpfpm bash
```
[docker-php-extension-installer]: https://github.com/mlocati/docker-php-extension-installer
[custom_php.ini]: customPHPConf/custom_php.ini
[dockerfile]:DockerFile
[mysite.conf]:nginxConf/mysite.conf
[customPHPConf]: customPHPConf
[syedusmanali/php-fpm]: https://hub.docker.com/r/syedusmanali/php-fpm
