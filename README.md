AUTOMATED FLASK DEPLOYMENT: END-TO-END CI/CD PIPELINE

A beginner-to-intermediate DevOps project demonstrating a fully automated CI/CD lifecycle. This project automates the packaging of a Python Flask application into a Docker container, stores it in a private cloud registry, and dynamically provisions AWS infrastructure using Terraform to host the application.

PROJECT ARCHITECTURE:
The pipeline follows this workflow:

A. Developer pushes code to GitHub (Branch: master).

B. GitHub Webhook triggers a Jenkins Pipeline.

C. Jenkins builds a Docker image of the Flask app.

D. Jenkins pushes the image to AWS ECR (Sydney Region).

E. Terraform provisions a t3.medium EC2 instance and Security Groups.

F. EC2 User Data automatically installs Docker, pulls the image from ECR, and runs the container.

TOOLS & TECHNOLOGIES (TECH STACK)

1. Application: Python (Flask)

2. CI/CD: Jenkins

3. Containerization: Docker

4. Registry: Amazon Elastic Container Registry (ECR)

5. Infrastructure as Code: Terraform

6. Cloud Provider: AWS (EC2, VPC, IAM)

7. Environment: Ubuntu 26.04 LTS

KEY CONFIGURATION HIGHLIGHTS
1. The Jenkinsfile---
We utilized a Declarative Pipeline with environment variables and withCredentials blocks to handle secure AWS authentication. This ensured our Access Keys remained encrypted within Jenkins and never exposed in the source code.

2. Terraform (IaC)---
The infrastructure was defined in main.tf, using variables to allow Jenkins to pass the specific Docker image_tag dynamically. This ensured the newest version of the app was deployed every time the pipeline ran.

TROUBLESHOOTS AND KEY LEARNINGS:
Every DevOps project has its hurdles. Here is how we troubleshot and resolved the challenges encountered during development:

1. Jenkins Executor "Pending" Trap---
Issue: Builds stayed in a "Pending" state, waiting for executors.

Resolution: Discovered Jenkins had taken the node offline due to a "Low Disk Space" threshold (under 1GiB). We reconfigured the Node Monitors and cleared /tmp space to bring the server back online.

2. Docker Permission Denied---
Issue: Jenkins failed to run Docker commands.

Resolution: Added the jenkins user to the docker group on the Ubuntu host (sudo usermod -aG docker jenkins) and restarted the service.

3. Missing CLI Binaries---
Issue: Stage 4 failed because the aws command was not found.

Resolution: Installed the AWS CLI directly on the Jenkins EC2 instance and restarted the service to update the system path.

4. Terraform "No Configuration Files"---
Issue: Terraform failed to find main.tf despite it being in the repo.

Resolution: Debugged the directory mapping. We adjusted the Jenkinsfile to run commands from the root directory where the files were actually committed, rather than an empty subdirectory.

HOW TO REPLICATE?
1. Clone the repository.

2. AWS Setup: Create an ECR repository named cicdflask.

3. Jenkins Setup:

4. Install Docker and Terraform on the host machine.

5. Add AWS credentials to Jenkins with ID aws-credentials.

6. Trigger: Push a change to your repository or manually click Build Now.

FINAL RESULT:-

The project concludes with a fully accessible Flask application running on a dynamically created AWS instance.

1. Access the App: http://<EC2_PUBLIC_IP>:5000

2. Cleanup: Use terraform destroy to tear down resources and avoid extra billing.
