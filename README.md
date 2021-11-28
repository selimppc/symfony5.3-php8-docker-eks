# symfony5.3-php8-docker-eks
 --- Symfony5 PHP8 DOCKER ESK | Cluster | POD ---

# Step 0: 

    A. Setup Application 
    b. Run application 

# Step 1: 

    a. Build image ( . [dot] is  important )
    b. Add tag to the image
    c. Push image to Docker Hub
    
    see the below example:

#### DOCKER IMAGE
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

# Step 2: 
    A. Create IAM from AWS account.

        Reference: for more info: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html

    B. Allow permission for EKS policies.

        Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html

    C. Get and Store credentials.

    see the below configuation:

#### AWS Configure
    Update AWS config:
    $ aws configure

    OR check file:
    $ vi ~/.aws/credentials
    $ vi ~/.aws/config


# Step 3:  Create Cluster  using `eksctl`
#### A. Install `eksctl` according to OS

    $ brew install eksctl

###### Reference: https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html

#### B. Check `eksctl` version or status

    $ eksctl version

###### Reference: https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html

#### C. To create cluster follow the below format:
    
    $ eksctl create .....


###### Reference: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html

# Step 4: Apply the deployment YAML file using `kubectl`




