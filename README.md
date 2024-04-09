<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/2109px-Kubernetes_logo_without_workmark.svg.png" width="100" alt="project-logo">
</p>
<p align="center">
    <h1 align="center">K8S-CLUSTER-PROXMOX-TERRAFORM</h1>
</p>
<p align="center">
    <em>Orchestrating scalability, networking, and storage with ease.</em>
</p>
<p align="center">
	<img src="https://img.shields.io/github/last-commit/AlxFrst/k8s-cluster-proxmox-terraform?style=default&logo=git&logoColor=white&color=0080ff" alt="last-commit">
	<img src="https://img.shields.io/github/languages/top/AlxFrst/k8s-cluster-proxmox-terraform?style=default&color=0080ff" alt="repo-top-language">
	<img src="https://img.shields.io/github/languages/count/AlxFrst/k8s-cluster-proxmox-terraform?style=default&color=0080ff" alt="repo-language-count">
<p>
<p align="center">
	<!-- default option, no dependency badges. -->
</p>

<br><!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary><br>

- [ Overview](#-overview)
- [ Features](#-features)
- [ Repository Structure](#-repository-structure)
- [ Modules](#-modules)
- [ Getting Started](#-getting-started)
  - [ Installation & Usage ](#-installation)
- [ Contributing](#-contributing)
</details>
<hr>

##  Overview

The k8s-cluster-proxmox-terraform project orchestrates the deployment of a Kubernetes cluster on Proxmox using Terraform. It automates the setup of Kubernetes master and worker nodes, storage nodes, and a HAProxy load balancer. By streamlining the configuration of network connections, software installations, and resource provisioning, this project simplifies the creation of scalable and resilient Kubernetes environments. With a focus on ease of deployment and management, it offers a valuable solution for users looking to quickly establish robust Kubernetes clusters on Proxmox infrastructure.

---

##  Features

|    |   Feature         | Description |
|----|-------------------|---------------------------------------------------------------|
| ⚙️  | **Architecture**  | Infrastructure setup for a Kubernetes cluster on Proxmox using Terraform. Key components include master nodes, worker nodes, storage nodes, load balancer, and essential configurations. |
| 🔩 | **Code Quality**  | Codebase exhibits clear structure and organization. Follows best practices for Terraform configurations. |
| 📄 | **Documentation** | Well-documented with detailed explanations of configuration files, variables, and setup procedures. README provides clear instructions for deployment. |
| 🔌 | **Integrations**  | Relies on Proxmox API for VM management and Kubernetes components for cluster setup. |
| 🧩 | **Modularity**    | Modular design with separate configuration files for different components, promoting code reusability and maintainability. |
| 🧪 | **Testing**       | Testing frameworks not explicitly mentioned in the repository details. |
| ⚡️  | **Performance**   | Efficient resource allocation and network setup for optimal performance. Load balancer enhances traffic distribution and scalability. |
| 🛡️ | **Security**      | Utilizes SSH keys for secure connections, cloud-init for VM initialization, and TLS settings for API interactions. Follows security best practices for infrastructure deployment. |
| 📦 | **Dependencies**  | Dependencies include Terraform for infrastructure management and Python libraries. |
| 🚀 | **Scalability**   | Designed for scalability with provisions for adding more worker nodes, storage nodes, and load balancers to handle increased cluster load. |

---

##  Repository Structure

```sh
└── k8s-cluster-proxmox-terraform/
    ├── assets
    │   └── joinExtractor.py
    ├── configurations
    │   └── prod.tfvars.exemple
    ├── k8s_loadbalancer.tf
    ├── k8s_master.tf
    ├── k8s_master_main.tf
    ├── k8s_storage.tf
    ├── k8s_worker.tf
    ├── main.tf
    └── variables.tf
```

---

##  Modules

<details closed><summary>.</summary>

| File                                                                                                            | Summary                                                                                                                                                                                                                                                               |
| ---                                                                                                             | ---                                                                                                                                                                                                                                                                   |
| [k8s_master_main.tf](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/blob/master/k8s_master_main.tf)   | Implements Kubernetes master VM deployment, incorporating necessary configurations and tools setup. Establishes key network connections, deploys essential software components, and initializes the cluster with specialized resources.                               |
| [k8s_worker.tf](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/blob/master/k8s_worker.tf)             | Creates Proxmox VMs for Kubernetes workers, configures network settings, and provisions packages. Establishes SSH connection for setup, fetches workerJoin script, and executes it to join master nodes.                                                              |
| [k8s_master.tf](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/blob/master/k8s_master.tf)             | Deploys Kubernetes master nodes on Proxmox using Terraform. Ensures cloud-init configuration, networking, SSH setup, and software installation via remote-exec provisioner. Implements Docker, containerd, Kubernetes components, and joins master nodes after setup. |
| [k8s_storage.tf](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/blob/master/k8s_storage.tf)           | Creates storage nodes in the Proxmox VM cluster. Configures NFS server, helm, and storage provisioning. Ensures high availability and scalability for Kubernetes storage.                                                                                             |
| [variables.tf](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/blob/master/variables.tf)               | Defines variables for Proxmox API, networking, VM configuration, Kubernetes cluster specifics, load balancer settings, node resources, and IP addressing within the Terraform infrastructure for a Kubernetes cluster on Proxmox.                                     |
| [main.tf](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/blob/master/main.tf)                         | Defines Proxmox provider configuration for managing infrastructure.uses API URL, token for authentication, and TLS settings. Crucial for interacting with Proxmox VMs in the Kubernetes cluster deployment through Terraform.                                         |
| [k8s_loadbalancer.tf](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/blob/master/k8s_loadbalancer.tf) | Defines a Proxmox virtual machine for a HAProxy load balancer, handling cluster traffic & API server requests. Conducts software installations & configurations for Kubernetes cluster management.                                                                    |

</details>

<details closed><summary>configurations</summary>

| File                                                                                                                           | Summary                                                                                                                                                                                                                                                       |
| ---                                                                                                                            | ---                                                                                                                                                                                                                                                           |
| [prod.tfvars.exemple](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/blob/master/configurations/prod.tfvars.exemple) | Specifies essential configuration variables for a Proxmox cluster deployment, including API details, network settings, SSH keys, VM parameters, and node specifics such as CPU, memory, and IP addresses. Crucial for setting up a robust Kubernetes cluster. |

</details>

---

##  Getting Started

**System Requirements:**

* **Terraform**: `1.6.4`
* **Proxmox**: `8.1.3`

### Before you begin
Prepare a cloud-init template on your Proxmox server. You can use the following repository to create a cloud-init template: [Proxmox Cloud-Init Imager](https://github.com/AlxFrst/Proxmox-cloudinit-imager)

###  Installation & Usage

<h4>From <code>source</code></h4>

> 1. Clone the k8s-cluster-proxmox-terraform repository:
>
> ```console
> git clone https://github.com/AlxFrst/k8s-cluster-proxmox-terraform
> ```
>
> 2. Change to the project directory:
> ```console
> cd k8s-cluster-proxmox-terraform
> ```
>
> 3. Install the dependencies:
> ```console
> terraform init
> ```
> 4. Copy the `prod.tfvars.exemple` file to `prod.tfvars` and fill in the necessary configuration details.
> ```console
> cp configurations/prod.tfvars.exemple configurations/prod.tfvars
> ```
> 5. Plan the Terraform deployment:
> ```console
> terraform plan -var-file=configurations/prod.tfvars
> ```
> 6. If the plan looks good, apply the Terraform configuration:
> ```console
> terraform apply -var-file=configurations/prod.tfvars
> ```
> 7. After the deployment is complete, access the Kubernetes cluster by the Load Balancer IP address and check the nodes:
> ```console
> kubectl get nodes
> ```

---

##  Contributing

Contributions are welcome! Here are several ways you can contribute:

- **[Report Issues](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/issues)**: Submit bugs found or log feature requests for the `k8s-cluster-proxmox-terraform` project.
- **[Submit Pull Requests](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/blob/main/CONTRIBUTING.md)**: Review open PRs, and submit your own PRs.
- **[Join the Discussions](https://github.com/AlxFrst/k8s-cluster-proxmox-terraform/discussions)**: Share your insights, provide feedback, or ask questions.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the project repository to your github account.
2. **Clone Locally**: Clone the forked repository to your local machine using a git client.
   ```sh
   git clone https://github.com/AlxFrst/k8s-cluster-proxmox-terraform
   ```
3. **Create a New Branch**: Always work on a new branch, giving it a descriptive name.
   ```sh
   git checkout -b new-feature-x
   ```
4. **Make Your Changes**: Develop and test your changes locally.
5. **Commit Your Changes**: Commit with a clear message describing your updates.
   ```sh
   git commit -m 'Implemented new feature x.'
   ```
6. **Push to github**: Push the changes to your forked repository.
   ```sh
   git push origin new-feature-x
   ```
7. **Submit a Pull Request**: Create a PR against the original project repository. Clearly describe the changes and their motivations.
8. **Review**: Once your PR is reviewed and approved, it will be merged into the main branch. Congratulations on your contribution!
</details>

<details closed>
<summary>Contributor Graph</summary>
<br>
<p align="center">
   <a href="https://github.com{/AlxFrst/k8s-cluster-proxmox-terraform/}graphs/contributors">
      <img src="https://contrib.rocks/image?repo=AlxFrst/k8s-cluster-proxmox-terraform">
   </a>
</p>
</details>
j