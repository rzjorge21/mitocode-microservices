pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'jdk-17'
    }

    environment {
        SONAR_HOST_URL = 'http://localhost:9000'
        ARTIFACTORY_URL = 'http://localhost:8081/artifactory'
        ARTIFACTORY_REPO = 'mitocode'
        ARTIFACTORY_CREDS = 'ARTIFACTORY_CREDENTIALS'
        DOCKERHUB_CREDS = credentials('DOCKERHUB_CREDENTIALS')
        DOCKER_IMAGE = 'rzjorge21/mitocode-microservices'
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean compile -B -ntp'
            }
        }

        // stage('Testing') {
        //     steps {
        //         sh 'mvn test -B -ntp'
        //     }
        //     post {
        //         success {
        //             junit 'target/surefire-reports/*.xml'
        //         }
        //         failure { 
        //             echo 'Tests failed!'
        //         }
        //     }
        // }
        // stage('Coverage') {
        //     steps {
        //         sh 'mvn jacoco:report -B -ntp'
        //     }
        //     post { 
        //         success { 
        //             recordCoverage(
        //                 tools: [[parser: 'JACOCO']],
        //                 sourceCodeRetention: 'EVERY_BUILD',
        //                 qualityGates: [
        //                     [threshold: 60.0, metric: 'LINE', criticality: 'FAILURE'],
        //                 ]
        //             )
        //         }
        //     }  
        // }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('SonarQube') {
                        sh """
                        mvn sonar:sonar -B -ntp \
                          -Dsonar.projectKey=mitocode-microservices \
                          -Dsonar.host.url=$SONAR_HOST_URL \
                          -Dsonar.login=$SONAR_TOKEN \
                          -Dsonar.java.coveragePlugin=jacoco \
                          -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml \
                          -Dsonar.coverage.exclusions=**/test/** \
                          -Dsonar.test.exclusions=**/test/** \
                          -Dsonar.java.test.exclusions=**/test/**
                        """
                    }
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        // stage('Package') {
        //     steps {
        //         sh 'env | sort'
        //         sh 'mvn clean package -DskipTests -B -ntp'
        //     }
        // }
        
        // stage('Build Docker Image') {
        //     steps {
        //         script {
        //             def pom = readMavenPom file: 'pom.xml'
        //             env.IMAGE_TAG = "${pom.version}-${env.BUILD_NUMBER}"
                    
        //             sh """
        //                 docker build -t ${DOCKER_IMAGE}:${env.IMAGE_TAG} .
        //                 docker build -t ${DOCKER_IMAGE}:latest .
        //             """
        //         }
        //     }
        // }
        // stage('Push to DockerHub') {
        //     steps {
        //         script {
        //             sh "echo ${DOCKERHUB_CREDS_PSW} | docker login -u ${DOCKERHUB_CREDS_USR} --password-stdin"
                    
        //             sh """
        //                 docker push ${DOCKER_IMAGE}:${env.IMAGE_TAG}
        //                 docker push ${DOCKER_IMAGE}:latest
        //             """
                    
        //             echo "Imagen Docker publicada: ${DOCKER_IMAGE}:${env.IMAGE_TAG}"
        //         }
        //     }
        // }
    }
    post { 
        always { 
            sh 'docker logout'
            cleanWs()
        }
    } 
}
