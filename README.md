# laraedit-docker [![GitHub issues](https://img.shields.io/github/issues/laraedit/laraedit-docker.svg)](https://github.com/laraedit/laraedit-docker/issues) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/laraedit/laraedit-docker/master/LICENSE) [![GitHub forks](https://img.shields.io/github/forks/laraedit/laraedit-docker.svg)](https://github.com/laraedit/laraedit-docker/network) [![GitHub stars](https://img.shields.io/github/stars/laraedit/laraedit-docker.svg)](https://github.com/laraedit/laraedit-docker/stargazers)
Dockerized version of Laravel Homestead

# Documentation
For now you can [check out the wiki](https://github.com/laraedit/laraedit-docker/wiki) for details on using the container. Once the container is stable, I will add more instructions here in the readme.

# Build Information
You can find the latest build details on the [Docker Hub](https://hub.docker.com/r/laraedit/laraedit/)

# What works
- [x] Nginx 1.8.1
- [x] PHP 7.0
- [x] SQLite
- [x] MySQL 5.7
- [x] Redis
- [x] NodeJS
- [ ] PostgreSQL
- [x] Beanstalkd
- [x] Blackfire
- [x] Bower
- [x] Gulp
- [x] Composer
- [x] Laravel Envoy
- [x] Laravel Installer
- [ ] Lumen Installer

# How to use the container
### Kitematic (the easy way)
  1. Search for `LaraEdit`
  2. Create LaraEdit container
  3. Point the `/var/www/html/app` volume to your local application directory.

### CLI (the other easy way)
  1. Pull in the image
  ```
    docker pull laraedit/laraedit
  ```  
  2. Run the container
  ```
    docker run -p 80:80 -v /path/to/your/app:/var/www/html/app laraedit/laraedit
  ```
  
**If you want to try the latest unstable release, replace `laraedit/laraedit` with `laraedit/laraedit:dev`**

# MySQL Details

- MySQL Username = `homestead`
- MySQL Password = `secret`
- MySQL Database = `homestead`

You are free to create more databases and/or users, but these are available to you as soon as you run the container!
