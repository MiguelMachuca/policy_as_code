pipeline {
    agent any
    stages {
        stage('Policy Check - Conftest') {
            steps {
                script {
                    try {
                        // Comando principal con diagnóstico integrado
                        sh '''
                            echo "Ejecutando Conftest..."
                            docker run --rm -v $WORKSPACE:/project -w /project openpolicyagent/conftest test /project/lab1-conftest/manifests/deployment-insecure.yaml --policy /project/lab1-conftest/policies
                        '''
                    } catch (hudson.AbortException e) {
                        echo "Error de Conftest: ${e.message}"
                        // Ejecutar diagnóstico automáticamente en caso de error
                        sh '''
                            echo "=== DIAGNÓSTICO AUTOMÁTICO ==="
                            docker run --rm -v $WORKSPACE:/project -w /project alpine find /project -name "*.yaml" -o -name "*.rego"
                        '''
                        error("Parando la pipeline por error en Conftest")
                    }
                }
            }
        }
        stage('Policy Check - Checkov') {
            steps {
                sh '''
                    docker run --rm -v $WORKSPACE:/project bridgecrew/checkov:latest -d /project/lab2-checkov/terraform
                '''
            }
        }
    }
    post {
        always { 
            echo 'Policy checks completed' 
        }
        failure {
            echo 'La pipeline falló - revisa los diagnósticos arriba'
        }
    }
}