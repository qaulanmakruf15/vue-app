def builderDocker
def CommitHash

pipeline {
    
    agent any

    parameters {
        booleanParam(name: 'RUNTEST', defaultValue: true, description: 'Toggle this value for testing')
        choice(name: 'CICD', choices: ['CI', 'CICD'], description: 'Pick something')
    }

    stages {
        stage('Build') { 
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
                    builderDocker = docker.build("123160087/vue-app:${CommitHash}")
                }
            }
        }

        stage('Test') {
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
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: 'Development',
                            verbose: false,
                            transfers: [
                                sshTransfer(
                                    execCommand: 'docker pull 123160087/vue-app:main; docker kill vue-app; docker run -d --rm --name 123160087/vue-app:main -p 8080:80 123160087/vue-app:main',
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