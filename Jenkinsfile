def builderDocker
def CommitHash

pipeline {

    agent any

    parameters {
        booleanParam(name: 'RUNTEST', defaultValue: true, description: 'Toggle this value fro testing')
        choice(name: 'CICD', choices: ['CI', 'CICD'], description: 'Pick something')
    }

    stages {

        stage('Build Project') {
            steps {
                nodejs("node12") {
                    sh 'yarn install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    CommitHash = sh (script : "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    builderDocker = docker.build("qaulanmakruf15/vue-app:${CommitHash}")
                }
            }
        }

        stage('Run Testing') {
            when {
                expression {
                    params.RUNTEST
                }
            }
            steps {
                script {
                    builderDocker.inside {
                        sh 'echo passed'
                    }
                }
            }
        }

        stage('Push Image') {
            when {
                expression {
                    params.RUNTEST
                }
            }

            steps {
                script {
                    builderDocker.push("${env.GIT_BRANCH}")
                }
            }
        }

        stage('Deploy') {
            when {
                expression {
                    params.CICD == 'CICD'
                }
            }
            steps {
                script {
                    sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: 'Development',
                                verbose: false,
                                transfers: [
                                    sshTransfer(
                                        execCommand: 'docker pull qaulanmakruf15/vue-app:main; docker kill vue-app; docker run -d --rm --name vue-app -p 8080:80 qaulanmakruf15/vue-app:main',
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