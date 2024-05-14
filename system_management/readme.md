# System Management

This directory contains all the configuration management and infrastructure as code files used to manage the infrastructure in my master thesis project. The files are primarily written for Terraform and Puppet, which were installed on the master server to automate deployment and configuration tasks.

## Purpose

The content within this directory serves primarily to document the processes and configurations used during the thesis project. **These files are intended for documentation and archival purposes and are not designed for direct reuse in other projects.** They provide a detailed record of the infrastructure setup and can be used as a reference or a starting point for similar setups, but they may require modifications to fit other specific environments or requirements.

## Directory Structure

Here is a breakdown of the `system_management` directory's structure and the contents of each file and subdirectory:

- **`central_data_repository_server.tf`**:
  - Terraform configuration file for setting up the central data repository server.

- **`configuration_management`**:
  - Directory containing Puppet manifests and automation scripts.
  
  - **`automation_scripts`**:
    - Contains scripts designed to streamline Git and DVC operations:
      - **`full_checkout_script.sh`**: Script to automate the checkout process for all necessary Git repositories, ensuring that DVC configurations are correctly synchronized.
      - **`full_push_script.sh`**: Script to automate the push process to Git repositories while handling DVC tracked files, ensuring that all changes are correctly committed and pushed.

  - **`central_data_repository_manifest.pp`**:
    - Puppet manifest to configure settings specific to the central data repository.

  - **`development_manifest.pp`**:
    - Puppet manifest for setting up and maintaining the development environment configurations.

  - **`dvc_remote_manifest.pp`**:
    - Puppet manifest for configuring the DVC (Data Version Control) remote storage settings.

- **`development_server.tf`**:
  - Terraform file for provisioning and managing the development server infrastructure.

- **`dvc_remote_storage_server.tf`**:
  - Terraform configuration for setting up the server that hosts the DVC remote storage.

- **`output.tf`**:
  - Terraform outputs that provide useful information post-deployment, such as IP addresses.

- **`providers.tf`**:
  - Terraform provider configuration that specifies the necessary providers (openstack in this case)

- **`variables.tf`**:
  - Terraform variables file defining and initializing variables used across other Terraform files.

## Usage

These scripts and configurations are primarily provided for documentation and archival purposes to illustrate the setup and management processes used during the thesis project. While the files are not intended for direct reuse without modification, they can serve as valuable resources for understanding the infrastructure and configurations used:

- **Review and Adaptation**: Users interested in these configurations can review and adapt the code to fit their specific requirements or use them as a learning tool to understand infrastructure as code and configuration management practices.

- **Installation and Configuration**: Ensure that Terraform and Puppet are correctly installed on your system before attempting to use any of these scripts. Modifications may be required to align with your environment and setup specifics.

