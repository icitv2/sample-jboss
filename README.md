"# sample-jboss" 
Testpp9991118880ssss
phases:
  pre_build:
    commands:
      - pip install awscli --upgrade --user
      - echo `aws --version`
      - echo Entered the install phase...
      - apt-get update -y
      - apt-get install -y maven
      - apt-get install -y openjdk-8-jdk














