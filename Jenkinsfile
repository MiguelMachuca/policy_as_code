pipeline {
  agent any
  stages {
    stage('Policy Check - Conftest') {
      steps {
        sh '''docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy /project/lab1-conftest/policies /project/lab1-conftest/manifests/deployment-insecure.yaml'''
      }
    }
    stage('Policy Check - Checkov') {
      steps {
        sh '''docker run --rm -v $(pwd):/project bridgecrew/checkov:latest -d /project/lab2-checkov/terraform'''
      }
    }
  }
  post {
    always { echo 'Policy checks completed' }
  }
}