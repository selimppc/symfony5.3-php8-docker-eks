# symfony5.3-php8-docker-eks
Symfony5 PHP8 DOCKER ESK | Cluster | POD

## DOCKER IMAGE
    Build Image
    $ docker build . -t <app_name>

    Run Image in Local:
    $ docker run -p 127.0.0.1:80:80 <app_name>

    Login:
    $ docker login -u <username> -p <password>
    
    Add Tag:
    $ docker tag <tag_name> <image>:<tag>

    push to docker:
    $  docker push <image>:<tag>

## AWS Configure
    Update AWS config:
    $ aws configure

    OR check file:
    $ vi ~/.aws/credentials
    $ vi ~/.aws/config
