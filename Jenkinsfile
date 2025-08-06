@Library('Shared') _
pipeline{
    agent any

    environment{
        SONAR_HOME = tool "Sonar"
    }

    parameters{
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
    }

    stages{

        stage("Validate Parameters") {
            steps{
                script{
                    if(params.FRONTEND_DOCKER_TAG == '' || params.BACKEND_DOCKER_TAG == ''){
                        error("Tag must be provided")
                    }
                }
            }
        }

        stage("Workspace cleanup"){
            steps{
                script{
                    cleanWs()
                }
            }
        }

        stage("Git : Code Clone"){
            steps{
                script{
                    clone("https://github.com/HrishiDarade/wanderlust.git", "main")
                }
            }
        }

        stage("Trivy: Filesystem Scan"){
            steps{
                script{
                    trivy_scan()
                }
            }
        }

        stage("OWASP: Dependency Check"){
            steps{
                script{
                    owasp_dependency()
                }
            }
        }

        stage("SonarQube: Code Analysis"){
            steps{
                script{
                    sonarqube_analysis("Sonar", "wanderlust", "wanderlust")
                }
            }
        }

        stage("SonarQube: Code Quality Gates"){
            steps{
                script{
                    sonarqube_code_quality()
                }
            }
        }

        stage("Exporting Environment Variables"){
            parallel{
                stage("Backend env setup"){
                    steps{
                        script{
                            dir("Automations"){
                                sh "bash updatebackend.sh"
                            }
                        }
                    }
                }
                stage("Frontend env setup"){
                    steps{
                        script{
                            dir("Automations"){
                                sh "bash updatefrontend.sh"
                            }
                        }
                    }
                }
            }
        }

        stage("Docker: Build Images"){
            steps{
                script{
                    dir("backend"){
                        docker_build("wanderlust-backend", "${params.BACKEND_DOCKER_TAG}")
                    }
                    dir("frontend"){
                        docker_build("wanderlust-frontend", "${params.FRONTEND_DOCKER_TAG}")
                    }
                }
            }
        }

        stage("Docker: Push to DockerHub"){
            steps{
                script{
                    docker_push("wanderlust-backend", "${params.BACKEND_DOCKER_TAG}")
                    docker_push("wanderlust-frontend", "${params.FRONTEND_DOCKER_TAG}")
                }
            }
        }
    }
    post{
        success{
            archiveArtifacts artifacts: '*.xml', followSymlinks: false
            build job: "Wanderlust-CD", parameters: [
                string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}") 
            ]
        }
    }

}