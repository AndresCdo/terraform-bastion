pipeline {
  agent any

  environment {
    GCP_PROJECT_ID = "cellular-automata-2023"
    GCP_REGION = "us-central1"
    SERVICE_ACCOUNT_KEY = credentials("gcp-service-account-key.json")
  }

  stages {
    stage("Checkout") {
      steps {
        git "https://github.com/AndresCdo/terraform-bastion.git"
      }
    }

    stage("Terraform Init") {
      steps {
        withCredentials([string(credentialsId: 'gcp-service-account-key', variable: 'SERVICE_ACCOUNT_KEY')]) {
          sh "gcloud auth activate-service-account --key-file=<(echo '$SERVICE_ACCOUNT_KEY')"
          sh "cd terraform-bastion && terraform init"
        }
      }
    }

    stage("Terraform Plan") {
      steps {
        withCredentials([string(credentialsId: 'gcp-service-account-key', variable: 'SERVICE_ACCOUNT_KEY')]) {
          sh "cd terraform-bastion && terraform plan -var project_id=$GCP_PROJECT_ID -var region=$GCP_REGION"
        }
      }
    }

    stage("Terraform Apply") {
      steps {
        withCredentials([string(credentialsId: 'gcp-service-account-key', variable: 'SERVICE_ACCOUNT_KEY')]) {
          sh "cd terraform-bastion && terraform apply -auto-approve -var project_id=$GCP_PROJECT_ID -var region=$GCP_REGION"
        }
      }
    }

    stage("Destroy Resources") {
      when { 
        anyOf {
          failure()
          aborted()
        }
      }
      steps {
        withCredentials([string(credentialsId: 'gcp-service-account-key', variable: 'SERVICE_ACCOUNT_KEY')]) {
          sh "cd terraform-bastion && terraform destroy -auto-approve -var project_id=$GCP_PROJECT_ID -var region=$GCP_REGION"
        }
      }
    }
  }
}
