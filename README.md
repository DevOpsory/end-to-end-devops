# End-to-End-DevOps
This repo contains code that is used to implement different stages of a DevOps journey, from application code to deployment on a target infrastructure. The code is intended to serve as an adoptable example for new entrants into DevOps and CI/CD. The code is arranged into 4 folders based on functionality and kept in this single repository to make it easy for beginners to follow through and recreate the deployment. In a real DevOps environment, the code will most likely be organized into different repos, following best practices on code separation. At the time of creating this project, maximum effort has been made to ensure that all the resources used in the deployment are free 😊, from cloud infrastructure to CI/CD tools. A more comprehensive article containing every step of the journey can be found _<<here: (insert article link)>>_. The article also breaks down key technical concepts in a non technical way to help beginners gain better understanding, so be sure to reference it if you find anything confusing.

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
Creates a monitoring instance using an official module provided by IBM cloud. Modules are predefined terraform templates that help organize and standardise infrastructure as code.









<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>


This is a minimal Java application using Maven and the latest stable JDK (Java 21).

## Structure
- `src/main/java/com/example/App.java`: Main application class
- `src/test/java/com/example/AppTest.java`: Unit tests
- `pom.xml`: Maven build configuration

## Build and Test

To build and run tests:

```sh
mvn clean install
```

To run the app:

```sh
mvn exec:java -Dexec.mainClass="com.example.App"
```

## Requirements
- JDK 21 or later
- Maven 3.8+
