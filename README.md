# symfony5.3-php8-docker-eks
Symfony5 PHP8 DOCKER ESK | Cluster | POD

Step 0: 

    a. Setup Application 
    b. Run application 

Step 1: 

    a. Build image ( . [dot] is  important )
    b. Add tag to the image
    c. Push image to Docker Hub
    
    see the below example:

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

Step 2: 
    a. Create IAM from AWS account.
    b. Allow permission for EKS policies.
    c. Get and Store credentials.


Step 3:  Create Cluster  using `eksctl`
    a. Install `eksctl` according to OS
    b. Check `eksctl` version or status
    c. To create cluster follow the below format:


Step 5: Apply the deployment YAML file using `kubectl`



## AWS Configure
    Update AWS config:
    $ aws configure

    OR check file:
    $ vi ~/.aws/credentials
    $ vi ~/.aws/config
