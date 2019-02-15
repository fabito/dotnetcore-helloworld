[![Build Status](https://dev.azure.com/fabiouechi/HelloWorld/_apis/build/status/fabito.dotnetcore-helloworld?branchName=master&jobName=Job)](https://dev.azure.com/fabiouechi/HelloWorld/_build/latest?definitionId=1&branchName=master)

# Hello World API

The HelloWorld API runs on Azure App Service on Linux and is deployed as Docker containers. This fully managed Azure service offers:

* autoscaling
* realtime monitoring
* realtime log analysis
* ability to perform blue/green deployment (using app deployment slots)

## Provisioning Azure resources with Terraform

In order to use Azure App Service there a few resources that should be created and configured (i.e. ResourceGroup, ServicePlan, AppService, etc).

Creating them through the GUI it's not a choice. Makes it very difficult to manage and replicate and it's too errorprone and tedious.

Alternatively we could use the `az` CLI utility and create a script to automate the task. That's better but there is a even better alternative: Terraform.

With Terraform we can represent the desired state of our infrastructure declaratively and easily add, change and remove resources.

The `infrastructure` folder contains Terraform module definitions to provision and configure the HelloWorld app within Azure.

After [having all prerequisites](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure) you can start using the commands below to manage the HelloWorld App cloud infrastructure.

```bash
# initialize terraform using a remote state
terraform init -backend-config="storage_account_name=" -backend-config="container_name=tfstate" -backend-config="access_key=" -backend-config="key=helloworld.tfstate"

# create the plan
terraform plan -out out.plan

# apply the plan
terraform apply out.plan

# destroy everything
terraform destroy
```

## CI/CD proccess

The Hello World app uses Azure Devops for CI/CD. Use the badge above to access the web console.

A build job is triggered on every push. The build process is described in details in the `azure-pipelines.docker.yml` file. The main steps are:

1. Compile, test and package the dotnet core application 
```bash
dotnet build 
dotnet test
dotnet publish
```
2. Build the Docker image and push to Docker Hub
```bash
docker build
docker login
docker push
```
If any of the steps above fail the build job fails and an email notification is sent. Otherwise the job succeeds and a release pipeline is automatically triggered.

The release pipeline contains 2 stages: `staging` and `production`. Once it's triggered it automatically deploys to `staging`. After a succesfull deploy there is a post-deployment gate that tests the HelloWorld API. It performs a simple `HTTP GET` request to the `/values` endpoint and checks if the response code is `2XX`.

At this point we have 2 versions running (blue and green) in paralell. The previous version is in `production` and the latest is in `staging`.

If the `staging` smoke tests succeed the pipeline proceeds to the next stage: `production`. This stage has a pre deployment approval condition and waits until an user's approval to continue. If approved the pipeline swaps the two stages and performs another smoke test in `production`. If the smoke test fails the swap is rolled back.

Its very easy to add new stages. We just need to add a new `azurerm_app_service_slot` resource and re apply the Terraform plan (see `infrastructure/app.tf`). Then we should restructure the release pipeline accordingly.

## Final thoughts

Ideally we should move the `infrastructure` assets to a separate git repo and configure a new CI/CD pipeline to automatically handle Terraform changes.

At the time of writing seems like Azure DevOps still don't provide a way to represent release pipelines as code. The whole setup described earlier was done through the GUI :-(

You can check the HelloWorld API in this urls:

```bash
#Staging: 
curl https://serko-helloworld-staging.azurewebsites.net/api/values

#Production 
curl https://serko-helloworld.azurewebsites.net/api/values
```

Since I couldn't use the Azure free account I destroyed the whole infrastructure to avoid the charges. Let me know if you need them up and running. It's just a `terraform apply` away ;-)