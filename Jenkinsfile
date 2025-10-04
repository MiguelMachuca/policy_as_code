pipeline {
  agent any
  stages {
    stage('Policy Check - Conftest') {
      steps {
        sh 'ls -la'
        sh 'pwd'
        sh '''docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy ./lab1-conftest/policies ./lab1-conftest/manifests/deployment-insecure.yaml'''
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