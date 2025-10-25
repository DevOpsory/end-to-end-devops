# End-to-End-DevOps
This repo contains code that is used to implement different stages of a DevOps journey, from application code to deployment on a target infrastructure. The code is intended to serve as an adoptable example for new entrants into DevOps and CI/CD. The code is arranged into 4 folders based on functionality and kept in this single repository to make it easy for beginners to follow through and recreate the deployment. In a real DevOps environment, the code will most likely be organized into different repos, following best practices on code separation. At the time of creating this project, maximum effort has been made to ensure that all the resources used in the deployment are free 😊, from cloud infrastructure to CI/CD tools. A more comprehensive article containing every step of the journey can be found here: [link-comming-soon](www.example.com). The article also breaks down key technical concepts in a non technical way to help beginners gain better understanding, so be sure to reference it if you find anything confusing.

## Code Organisation
### .github/workflows
This folder contains all the workflows that is used in this project. Workflows are yaml files containing all the steps(tasks) that we expect a runner to execute when a condition is met. The condition can be when you raise a pull request, push new code or click a manual run button. You can think of a runner as a cloud computer where we run our workflow steps. The files in the the folder are:
- `cicd.yml`<br>
Contains the CI/CD pipeline that builds and tests the application code, packages the code into a docker image, pushes the docker image to a private registry and deploys the image on IBM cloud
- `create_infra.yml`<br>
Contains a pipeline with terraform execution steps to create an IBM code engine project in which the application will be deployed
- `create_monitoring.yml`<br>
Contains a pipeline with terraform execution steps to create a monitoring instance on IBM cloud. The instance is used to collect metrics from the deployed app.
- `destroy_infra.yml`<br>
Contains terraform execution steps to destroy the IBM code engine project created using `create_infra.yml`. It is considered best practice to destroy cloud infrastructure when it is no longer in use.
- `destroy_monitoring`<br>
Contains terraform execution steps to destroy the monitoring instance created using `create_monitoring.yml`
### app
This folder contains a sample `hello world` app that is written in java with maven as the build tool. Building a code is the process of converting the code to an executable file that can run on a computer. The folder contains the following files and subfolder:
- `src`<br>
Sufolder containing the java source and test code for the app.
- `Dockerfile` <br>
Contains the information required to package the app into  a docker container. Packaging into a container or containerization is the process of packaging an app along with its dependencies so that it can run anywhere without the need to first install dependencies, i.e. we can run our java app without the neeed to first install java.
- `pom.xml`<br>
Contains a declaration of the dependencies and plugins required to successfully build the code. 
### infra
This folder contains the definition for the deployment infrastructure in terraform. Terraform is a language used for provisioning infrastructure resources through Infrastructure as Code (IaC). The files in the folder are:
- `provider.tf`<br>
Contains the definition for the cloud provider, IBM cloud in this case.
- `backend.tf`<br>
Declares the infrastructure workspace in terraform cloud. The workspace helps to hold the statefile which terraform uses to track the state of our resources and also holds the IBM cloud credentials which we cannot hardcode into our terraform files, following security best practices.
- `variables.tf`<br>
Declares the variables that we use in the rest of the terraform files. The variable values are stored in the infrastructure workspace in terraform cloud. They will be retrieved and inserted by terraform at run time.
- `code_engine.tf`<br>
Creates an IBM code engine project. IBM code engine is a serverless infrastructure offering from IBM for running containerised applications.
### monitoring
This folder contains the definition for the monitoring instance in terraform. The files in the folder are:
- `provider.tf`<br>
- `backend.tf`<br>
Declares the monitoring workspace in terraform cloud.
- `variables.tf`<br>
Variable values are stored in the monitoring workspace in terraform cloud.
- `monitor.tf`<br>
Creates a monitoring instance using an official module provided by IBM cloud. Modules are predefined terraform templates that help organise and standardise infrastructure as code.
## How to Create Your Own Deployment Using the Code in This Repo
There is an article that provides step by step guidance here: [link-comming-soon](www.example.com). If you are completely new to the described applications and concepts, you should follow the article for a more comprehensive guidance.
### Prerequisites
#### Setup your own Repository
- Fork this repository.
- Create a new environment called `production` and add yourself as a reviewer.
#### Setup Doppler
Doppler is an application used for secret management.
- Create a free doppler account to store the secrets used in the GitHub actions workflows: https://www.doppler.com/.
- Create a service token that will be used to fetch the stored tokens.
- Add the service token as a secret named `DOPPLER_TOKEN` in actions variables in your own fork of the repository.
- Create a new project in doppler and name it `sample-project`. This should create three environments `dev`, `stage` and `prod`. You will store your secrets in the `dev` environment.
#### Setup IBM Cloud
IBM cloud is used to host the infrastructure for deployment and monitoring.
- Create a free IBM Cloud account: https://cloud.ibm.com/.
- Create an IBM Cloud API Key.
#### Setup Terraform Cloud
Terraform is used to provision resources on IBM Cloud using IaC. Terraform cloud is used as a remote backend to store state files and variables.
- Create a free Terraform cloud account: https://app.terraform.io/.
- Create an organization, `end-to-end-devops`
- Create two workspaces in the organization, `end-to-end-devops-infra` and `end-to-end-devops-monitoring`.
- In each workspace, create a terraform variable called `ibmcloud_api_key` and set the value to the IBM Cloud API Key you created in the above step.
- Create a user API token and add it to the `dev` environment in the doppler `sample-project`as `TERRAFORM_TOKEN`.
#### Setup SonarCloud
SonarQube is a code scanning tool for scanning application code for quality issues and security hotspots.
- Create a free SonarCloud account: https://sonarcloud.io/.
- Generate an access token and add it to the doppler `sample-project` as `SONARQUBE_TOKEN`.
#### Setup Snyk
Snyk is a code scanning tool used to scan for vulnerabilities in external dependencies and plugins used in an application code.
- Create a free Snyk account: https://app.snyk.io/.
- Generate an auth token and add it to the doppler `sample-project` as `SNYK_TOKEN`.
#### Setup Cloudsmith
Cloudsmith is a package repository for storing artefacts such as executable binaries and docker images.
- Create a free Cloudsmith account: https://app.cloudsmith.com/.
- Create a personal API key and add it to the doppler `sample-project` as `CLOUDSMITH_TOKEN`
- Create a new workspace named `sample-workspace`.
- Create a new repository named `sample-docker-repo`.
### Create Deployment infra structure
Manually trigger the `create_infra.yml` GitHub workflow to create an IBM Cloud code engine project. The workflow has a `plan` job and an `apply` job. Approve the apply job after reviewing the planned changes.
### Test, Biuld and Deploy
The `cicd.yml` workflow contains steps to test, build the app and deploy to the code engine project created in the step above. The jobs in the workflow are triggered when changes are made to the application code and pushed upstream, when a pull request is raised or when the workflow is triggered manually. There are three jobs; `build-and-test`(Continuous Integration), `containerize-and-deliver`(Continuous Delivery) and `deploy`(Continuous Deployment). The `build-and-test` job tests and builds the application code to confirm changes made to it did not break it. This job runs on all branches in the repository.
The `containerize-and-deliver` job packages the app into a docker container and pushes the container to an upstream docker repository. The `deploy` job deploys the application to the code engine project created earlier. Note that both the `containerize-and-deliver` and the `deploy` job are only run when there is a push to the main branch or when the workflow is triggered from the main branch. After the deploy job is run, the job run will output a URL that you can visit and see the deployed app.
### Monitor the deployed application
Manually trigger the `create_monitoring.yml` GitHub workflow to create an IBM Cloud monitoring instance. The workflow only creates the instance but doesn't enable Platform Metrics. IBM cloud does not support enabling Platform Metrics via terraform or any other API call at the time this project was created. After creating the instance, login to IBM cloud, under observability -> monitoring -> monitoring instances, you will see an instance named `cloud-monitoring-*`. Enable platform metrics and set location to the location of the app. Once setup is complete, wait for some minutes and you should be able to see information about the deployed app in the monitoring instance dashboard.
## House Cleaning.
One of the best practices of DevOps is to clean up after resources are no longer needed. You can experiment with changing the app code or even play around with the ci/cd pipeline based on your level of experience, but once you are done with expierimenting, destroy the created cloud resources by doing the following:
- Run `destroy_infra.yml` to destroy the code engine project
- Run `destroy_monitoring.yml` to destroy the monitoring instance.

> [!CAUTION]
> IBM Cloud has a concept called reclaimations. This means that destroyed resources are kept in a state where they can be reclaimed for seven days.
> During the reclaimation period, you cannot create resources with the same name as resources in the reclaimation state.
> To create resources with the same name, you need to log into the IBM Cloud, go to the section where the resources reside and delete reclaimations.
> In other words, if you run and approve `destroy_infra.yml` (or `destroy_monitoring.yml`), running `create_infra.yml` (or `create_monitoring.yml`) will fail unless you delete reclaimations or wait for seven days.

