stage('Policy Check - Conftest') {
    steps {
        sh 'ls -la'
        sh 'pwd'
        sh 'ls -la ./lab1-conftest/manifests/deployment-insecure.yaml'
        // Add this diagnostic step
        sh '''
        docker run --rm -v $(pwd):/project -w /project alpine ls -la /project/lab1-conftest/manifests/
        '''
        sh '''
        docker run --rm -v $(pwd):/project -w /project openpolicyagent/conftest test ./lab1-conftest/manifests/deployment-insecure.yaml --policy ./lab1-conftest/policies 
        '''
    }
}