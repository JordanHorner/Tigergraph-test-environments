# Tigergraph docker images

<p align="left"> <a href="https://www.docker.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="docker" width="40" height="40"/> </a> </p>
 
 ## To run images :
Base image
```
  docker-compose up
```
Ldap or other branch container
```
  docker-compose  -f docker-compose.ldap.yml up
```

## Configuration:

You may be edit /utils/config.sh to run tigergraph config commands