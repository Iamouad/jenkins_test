pipeline {
    agent any
    stages {
        stage("Clone Git Repository") {
            steps {
                git(
                    url: "https://github.com/Iamouad/jenkins_test",
                    branch: "master",
                    changelog: true,
                    poll: true
                )
            }
        }
    }
}
