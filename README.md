# jenkins_test

## Intro
This is minimalist Nginx web server thats servers a static web page [https://github.com/Iamouad/jenkins_test/blob/main/index.html](index.html)
<br>

## Jenkins pipeline

A pipeline is configured in jenkins that listens to push events on the main branch of this project

[https://github.com/Iamouad/jenkins_test/blob/main/rollout-docker.sh](rollout-docker.sh)
This bash script does all the stages of the **CI/CD** of the app following  this steps:
1. Builds a new docker image of the web-server and tags it with the CI_COMMIT TAG
2. Deploys a test container in order to tets the new image
3. Upgrades the **main container** to the new version of the app
4. Rollback to the previous version in case of an upgrade failure

What jenkins logs look like: [https://github.com/Iamouad/jenkins_test/blob/main/jenkins_logs.txt](jenkins_logs.txt)
