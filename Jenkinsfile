def builderDocker
def CommitHash

pipeline {
    agent any
    parameters {
        booleanParam(name: 'RunTest', defaultValue: true, description: 'Toggle this value for testing')
        choice(name: 'CICD', choices: ['CI', 'CICD'], description: 'Pick something')
    }
    stages {
        stage('Build project') {
            steps {
                nodejs('nodejs12') {
                    sh 'yarn install'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    CommitHash = sh (script : "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    buildDocker = docker.build("qaulanmakruf15/vue-app:${CommitHash}")
                }
            }
        }
        stage('Run Testing') {
            when {
                expression {
                    params.RunTest
                }
            }
            steps {
                script {
                    buildDocker.inside {
                        sh 'echo passed'
                    }
                }
            }
        }
        stage('Push Image') {
            when {
                expression {
                    params.RunTest
                }
            }
            steps {
                script {
                    buildDocker.push("${env.GIT_BRANCH}")
                }
            }
        }
        stage('Deploy') {
            when {
                expression {
                    BRANCH_NAME == 'main'
                }
            }
            steps {
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: 'development',
                                verbose: false,
                                transfers: [
                                    sshTransfer(
                                        execCommand: "docker pull qaulanmakruf15/vue-env:${env.GIT_BRANCH}; docker kill vue-env; docker run -d --rm --name vue-env -p 80:80 qaulanmakruf/vue-env:${env.GIT_BRANCH}",
                                        execTimeout: 120000,
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }
    }
}