# laraedit-docker [![GitHub issues](https://img.shields.io/github/issues/laraedit/laraedit-docker.svg)](https://github.com/laraedit/laraedit-docker/issues) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/laraedit/laraedit-docker/master/LICENSE) [![GitHub forks](https://img.shields.io/github/forks/laraedit/laraedit-docker.svg)](https://github.com/laraedit/laraedit-docker/network) [![GitHub stars](https://img.shields.io/github/stars/laraedit/laraedit-docker.svg)](https://github.com/laraedit/laraedit-docker/stargazers)
Dockerized version of Laravel Homestead

```
This container is a work in progress and is not yet fully functional. I will 
remove this message when this container is safe to use.
```

# Documentation
For now you can [check out the wiki](https://github.com/laraedit/laraedit-docker/wiki) for details on using the container. Once the container is stable, I will add more instructions here in the readme.

# Build Information
You can find the latest build details on the [Docker Hub](https://hub.docker.com/r/laraedit/laraedit/)

# What works
- [x] Nginx 1.8.1
- [x] PHP 7.0
- [x] SQLite
- [ ] MySQL 5.7
- [ ] Redis
- [ ] NodeJS
- [ ] PostreSQL
- [ ] Blackfire
- [ ] Bower
- [ ] Gulp
- [ ] Composer
- [ ] Laravel Envoy
- [ ] Laravel Installer
- [ ] Lumen Installer

# How to use the container
### Kitematic (the easy way)
  1. Search for `LaraEdit`
  2. Create LaraEdit container
  3. Point the `/var/www/html/app` volume to your local application directory.

### CLI (the other easy way)
  - 1. Pull in the image
  ```
    docker pull laraedit/laraedit
  ```  
  - 2. Run the container
  ```
    docker run laraedit/laraedit -p 80:80 /path/to/your/app:/var/www/html/app
  ```

