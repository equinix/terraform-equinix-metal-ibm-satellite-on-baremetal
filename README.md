# Automated IBM Cloud Satellite on Equinix Metal

These files will allow you to use [Terraform](http://terraform.io) to deploy [IBM Cloud Satellite](https://cloud.ibm.com/docs/satellite?topic=satellite-getting-started) on [Equinix Metal's Bare Metal Cloud offering](http://metal.equinix.com).

Default values for this initial module version will bring up 3 nodes for the IBM Satellite Control Plane cluster and 3 worker nodes to assign them to data plane clusters later. The 3 worker nodes will appear in the IBM Cloud Satellite console as not assigned to any cluster. As next steps, the user will be responsible for attach these worker nodes to a satellite enabled service. For example, [creating a Red Hat® OpenShift® on IBM Cloud™ clusters in an IBM Cloud™ Satellite location.](https://cloud.ibm.com/docs/satellite?topic=openshift-satellite-clusters) 

Terraform will create RHEL machines for your IBM Cloud Satellite on Baremetal cluster registered to IBM Cloud®.

Users are responsible for providing their Equinix Metal account, and IBM Satellite subscription as described in this readme.

The build (with default settings) typically takes 60-90 minutes.

## Pre-Requisites

To use these Terraform files, you need to have the following Prerequisites:

* An Equinix Metal org-id and a [user-level Equinix Metal API key](https://metal.equinix.com/developers/docs/accounts/users/#api-keys) 
  or a [project-level Equinix Metal API Key](https://metal.equinix.com/developers/docs/accounts/projects/#api-keys)
* An Equinix Metal account, with the ability to provision servers, and the ability to SSH into them, and an user or project Equinix Metal API Key
* Set up an IBM Cloud® account if you do not have one already, and an IBM Cloud API Key
* Set up IBM Cloud® CLI or permission to use IBM Cloud Shell® 
* Terraform, it is a single binary file. Visit their download page choose the specific OS. Once downloaded make the binary executable and move into your environment path
* Git Clone IBM Cloud Satellite on bare-metal repo here

## Install tools

### Install Terraform

Terraform is just a single binary. Visit their [download page](https://www.terraform.io/downloads.html), choose your operating system, make the binary executable, and move it into your path.

Here is an example for **macOS**:

```bash
curl -LO https://releases.hashicorp.com/terraform/0.14.2/terraform_0.14.2_darwin_amd64.zip
unzip terraform_0.14.2_darwin_amd64.zip
chmod +x terraform
sudo mv terraform /usr/local/bin/
rm -f terraform_0.14.2_darwin_amd64.zip
```

Here is an example for **Linux**:

```bash
curl -LO https://releases.hashicorp.com/terraform/0.14.2/terraform_0.14.2_linux_amd64.zip
unzip terraform_0.14.2_linux_amd64.zip
chmod +x terraform
sudo mv terraform /usr/local/bin/
rm -f terraform_0.14.2_linux_amd64.zip
```

## Deploy the IBM Cloud Satellite cluster on Equinix Metal

To facilitate the deployment we have included a template that can be used to define your own terraform.tfvars file.
There you will find the main required variables. For a complete list of all customizable variables look at the variables.tf file.
Rename the template to terraform.tfvars and use your favorite text editor to define the required variables  

```bash
cp terraform.tfvars.template terraform.tfvars
vi terraform.tfvars
```

The table below describes the variables included in the terraform.tfvars.template file:

|     Variable Name             |  Type   |    Default Value      | Description                                                               |
| :---------------------------: | :-----: | :-------------------: | :------------------------------------------------------------------------ |
|    metal_create_project       | bool    |        false          | Create a Equinix Metal Project if this is 'true'                          |
|    metal_project_id           | string  |        n/a            | Equinix Metal Project ID. Required if 'metal_create_project' is 'false'   |
|    metal_api_auth_token       | string  |        n/a            | Equinix Metal API Key                                                     |
|    metal_device_metro         | string  |        "da"           | Equinix Metal metro location to deploy into. [More info](https://metal.equinix.com/developers/docs/locations/metros/#metros-quick-reference) |
|    control_plane_plan         | string  |        "c3.small.x86" | Equinix Metal device type to deploy control plane nodes. [More info](https://metal.equinix.com/developers/docs/servers/server-specs/#current-generation) |
|    data_plane_plan            | string  |        "c3.small.x86" | Equinix Metal device type to deploy data plane nodes. [More info](https://metal.equinix.com/developers/docs/servers/server-specs/#current-generation) |
|    stack_name                 | string  |        n/a            | Equinix Metal server name prefix I.e., "ibm-satellite-equinix-metal"      |
|    rhel_submanager_username   | string  |        n/a            | RHEL account username or email                                            |
|    rhel_submanager_password   | string  |        n/a            | RHEL account password                                                     |
|    ibm_cp_host_count          | string  |        3              | Number of baremetal control plane nodes                                   |
|    ibm_dp_host_count          | string  |        3              | Number of baremetal data plane nodes                                      |
|    ibm_create_location        | bool    |        true           | Whether to create a location or to use an existing one                    |
|    ibm_create_resource_group  | bool    |        false          | Whether to create a resource group or to use an existing one              |
|    ibm_resource_group_name    | string  |        "Default"      | Name of the IBM Cloud resource group project. Existing one /to create a new one |
|    ibm_sat_location_name      | string  |        n/a            | Name for a new IBM Cloud Satellite location. I.e., "MY_NEW_Location_Dallas"     |
|    ibm_sat_managed_from       | string  |        "wdc04"        | To list available regions, run 'ibmcloud ks locations' I.e., "wdc04"      |
|    ibm_cp_host_labels         | string  |        n/a            | Key-value pairs to label cp nodes. I.e., ["owner:me", "provider:equinix"] |
|    ibm_dp_host_labels         | string  |        n/a            | Key-value pairs to label cp nodes. I.e., ["owner:me", "type:worker"]      |
|    ibm_cloud_api_key          | string  |        n/a            | The IBM Cloud platform API Key                                            |
|    ibm_region                 | string  |        "us-east"      | Region of the IBM Cloud account. Supported: us-east and eu-gb region      |

Deploy the Equinix Metal IBM Satellite cluster:

First, it is highly recommended running a terraform plan to preview the changes that Terraform plans to make to your infrastructure:

```bash
terraform plan
```

All there is left to do now is to deploy the cluster:

```bash
terraform apply --auto-approve
```

This should end with output similar to this:

```console
Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

Control_Plane_public_IPs = [
  "147.75.47.19",
  "147.75.55.171",
  "147.75.55.211",
]
Equinix_Metal_project_ID = "af5b81d0-789d-456g-9900-e3d4ec36fb04"
SSH_key_location = "/home/ubuntu/.ssh/metal-ibm-satellite-prod-2x9hm"
Worker_public_IPs = [
  "139.178.85.221",
  "139.178.86.100",
  "139.178.86.50",
]
```

## NOTE

After assigning the host to a cluster, SSH access is disabled and access to the host is controlled via [IBM Cloud IAM access](https://cloud.ibm.com/docs/openshift?topic=openshift-users)

