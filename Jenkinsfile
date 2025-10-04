pipeline {
    agent any
    stages {
    stages {
        stage('Policy Check - Conftest') {
            steps {
                script {
                    try {
                        // Pequeña pausa para asegurar montaje del volumen
                        sleep 2
                        
                        sh '''
                            echo "Ejecutando Conftest..."
                            docker run --rm -v $WORKSPACE:/project -w /project openpolicyagent/conftest test /project/lab1-conftest/manifests/deployment-insecure.yaml --policy /project/lab1-conftest/policies
                        '''
                    } catch (hudson.AbortException e) {
                        echo "Error de Conftest: ${e.message}"
                        
                        // Diagnóstico automático MEJORADO
                        sh '''
                            echo "=== DIAGNÓSTICO DETALLADO ==="
                            echo "Workspace: $WORKSPACE"
                            echo "=== Estructura desde contenedor ==="
                            docker run --rm -v $WORKSPACE:/project -w /project alpine find /project -name "*.yaml" -o -name "*.rego"
                            echo "=== Contenido de lab1-conftest ==="
                            docker run --rm -v $WORKSPACE:/project -w /project alpine ls -la /project/lab1-conftest/
                        '''
                        
                        error("Parando la pipeline por error en Conftest")
                    }
                }
            }
        }
        stage('Policy Check - Checkov') {
            steps {
                sh '''
                    docker run --rm -v $WORKSPACE:/project bridgecrew/checkov:latest -d ./lab2-checkov/terraform
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