pipeline {
  agent any
  stages {
    stage('Policy Check - Conftest') {
        steps {
            sh 'pwd -P'
            sh 'ls -la'
            sh 'pwd'
            sh 'ls -la ./lab1-conftest/manifests/deployment-insecure.yaml'
            sh 'ls -la /var/jenkins_home/workspace/Lab3-2/lab1-conftest/manifests/'
            sh 'id' 
            // Add this diagnostic step
            sh '''
            docker run --rm -v $(pwd):/project -w /project alpine ls -la /project/lab1-conftest/manifests/
            '''
            sh '''
            docker run --rm -v $(pwd):/project -w /project openpolicyagent/conftest test ./lab1-conftest/manifests/deployment-insecure.yaml --policy ./lab1-conftest/policies 
            '''
        }
    }
    stage('Policy Check - Checkov') {
      steps {
        sh '''docker run --rm -v $(pwd):/project bridgecrew/checkov:latest -d ./lab2-checkov/terraform'''
      }
    }
  }
  post {
    always { echo 'Policy checks completed' }
  }
}