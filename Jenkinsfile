pipeline {
    agent any
    stages {
        stage("Clone Git Repository") {
            steps {
                git(
                    url: "https://github.com/Iamouad/jenkins_test",
                    branch: "main",
                    changelog: true,
                    poll: true
                )
            }
        }
    }
}
