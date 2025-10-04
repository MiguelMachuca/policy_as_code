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
            
            // Comando corregido para diagnóstico
            sh '''
            docker run --rm -v $WORKSPACE:/project -w /project alpine ls -la /project/lab1-conftest/manifests/
            '''
            
            // Comando principal corregido para Conftest
            sh '''
            docker run --rm -v $WORKSPACE:/project -w /project openpolicyagent/conftest test /project/lab1-conftest/manifests/deployment-insecure.yaml --policy /project/lab1-conftest/policies 
            '''
        }
    }
    stage('Policy Check - Checkov') {
      steps {
        // Comando corregido para Checkov
        sh '''docker run --rm -v $WORKSPACE:/project bridgecrew/checkov:latest -d /project/lab2-checkov/terraform'''
      }
    }
  }
  post {
    always { echo 'Policy checks completed' }
  }
}