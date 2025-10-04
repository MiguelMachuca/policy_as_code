pipeline {
  agent any
  stages {
    stage('Check Files') {
      steps {
        script {
            def filePath = 'lab1-conftest/manifests/deployment-insecure.yaml'
            if (fileExists(filePath)) {
                echo "✅ Archivo encontrado: ${filePath}"
            } else {
                echo "❌ Archivo NO encontrado: ${filePath}"
                sh 'find . -name "*deployment*" -type f 2>/dev/null || echo "No se encontraron archivos deployment"'
                error("Archivo requerido no encontrado: ${filePath}")
            }
        }
      }
    }
    stage('Policy Check - Conftest') {
        steps {
            sh 'ls -la' // Lists in Jenkins workspace
            sh '''
                docker run --rm -v $(pwd):/project -w /project openpolicyagent/conftest ls -la /project/lab1-conftest/manifests/
            '''
            sh '''
                docker run --rm -v $(pwd):/project -w /project openpolicyagent/conftest test --policy /project/lab1-conftest/policies /project/lab1-conftest/manifests/deployment-insecure.yaml
            '''
        }
    }
    stage('Policy Check - Checkov') {
      steps {
        sh '''docker run --rm -v $(pwd):/project -w /project bridgecrew/checkov:latest -d ./lab2-checkov/terraform'''
      }
    }
  }
  post {
    always { echo 'Policy checks completed' }
  }
}