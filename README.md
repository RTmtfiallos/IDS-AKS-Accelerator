<!-- DOCTOC SKIP -->
# ABC's Azure Kubernetes Service - Wizard/Configurator :D

Building Kubernetes clusters can be hard work!

<details>
<summary>
<i>Like this? </i>
<a href="http://www.ironspider.ca/format_text/fontstyles.htm">
Useful Source</a>
</summary>
<p>It's because the details block is html5. If you want to modify it your best bet is using html5. </p>
<details>
<summary>
<i>Like this? </i>
<a href="http://www.ironspider.ca/format_text/fontstyles.htm">
Useful Source</a>
</summary>
<p>It's because the details block is html5. If you want to modify it your best bet is using html5. </p>
</details>
</details>
<BR>
The Randstad team focuses on expediting ABC's onboarding of Azure Kubernetes Service workloads using best practices and a flexible templating approach to suit differing requirements.

I have combined guidance provided by the [AKS Secure Baseline](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks), [Well Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/), [Cloud Adoption Framework](https://azure.microsoft.com/en-gb/cloud-adoption-framework/) and [Enterprise-Scale](https://github.com/Azure/Enterprise-Scale) by providing tangible artifacts to deploy Azure resources from CLI or CI/CD systems.

## The 3 Components

We will focus equally over 3 areas, configuration, modular templating and CI implementation.

![project component areas](docassets/AKSBicepComponents.png)

### Wizard experience

To help guide your initial AKS configuration, use the [Deployment Helper](https://azure.github.io/Aks-Construction/), which will provide a set of parameters and scripts to make deployment simple. It uses several preset configurations to guide configuration decisions.

The deployment helper provides links to the official Microsoft documentation to help provide additional context for each feature.

[![preview screenshot of the helper wizard](helper_preview_es.png)](https://azure.github.io/Aks-Construction/)

### IaC - Bicep code files

IaC (Infrastructure as Code) code files have been modularised into their component areas. [Main.bicep](bicep/main.bicep) references them and they are expected to be present in the same directory. The Deployment Helper leverages an Arm json compiled version of all the bicep files.

Releases are used to version the bicep code files, they can be leveraged directly for use in your project or you can opt to Fork the repo if you prefer.

### DevOps - GitHub Actions

A number of [GitHub actions](https://github.com/Azure/Aks-Construction/tree/main/.github/workflows) are used in the repo that run on push/pr/schedules. These can be copied into your own repo and customised for your CI/CD pipeline. A robust deployment pipeline is essential when coordinating the deployment of multiple Azure services that work together, additionally there is configuration that cannot be set in the template and that needs to be automated (and tested) consistently.
![preview screenshot of the helper wizard](docassets/ghactionworkflow.jpg)

CI Name | Actions Workflow | Parameter file | CI Status | Notes
|--------|--------|--------|-----------|------|
| Starter cluster | [StandardCI.yml](https://github.com/Azure/Aks-Construction/blob/main/.github/workflows/StandardCI.yml) | [ESLZ Sandbox](.github/workflows_dep/AksDeploy-Basic.parameters.json) | [![AksStandardCI](https://github.com/Azure/Aks-Construction/actions/workflows/StandardCI.yml/badge.svg)](https://github.com/Azure/Aks-Construction/actions/workflows/StandardCI.yml) | A simple deployment example, good for first time users of this project to start with  |
| BYO Vnet | [ByoVnetCI.yml](https://github.com/Azure/Aks-Construction/blob/main/.github/workflows/ByoVnetCI.yml) | [ESLZ Byo peered vnet](.github/workflows_dep/AksDeploy-ByoVnet.parameters.json) | [![ByoVnetCI](https://github.com/Azure/Aks-Construction/actions/workflows/ByoVnetCI.yml/badge.svg?branch=main)](https://github.com/Azure/Aks-Construction/actions/workflows/ByoVnetCI.yml) | Comprehensive IaC flow deploying multiple smoke-test apps |
| Private cluster | [ByoVnetPrivateCI.yml](https://github.com/Azure/Aks-Construction/blob/main/.github/workflows/ByoVnetPrivateCI.yml) | [ESLZ Byo private vnet](.github/workflows_dep/AksDeploy-ByoVnetPrivate.parameters.json) | [![ByoVNetPrivateCI](https://github.com/Azure/Aks-Construction/actions/workflows/ByoVnetPrivateCI.yml/badge.svg)](https://github.com/Azure/Aks-Construction/actions/workflows/ByoVnetPrivateCI.yml)| As above, but with a focus on private networking |

For a more in depth look at the GitHub Actions I created, which steps are performed and the different CI practices they demonstrate, please refer to [this page](GhActions.md).

I have already begun work on an Azure DevOps pipeline as opposed to leveraging GitHub.

## Getting Started

### Basic

If this is the first time you are working with Bicep files, follow these steps.

1. Use the [Deployment Helper](https://azure.github.io/Aks-Construction/) to guide your AKS configuration.
2. Run the commands in the *Provision Environment* tab to create your AKS Environment in your Azure subscription
3. Run the commands in the *Post Configuration* tab to complete your implementation
4. [Connect to your AKS Cluster](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough#connect-to-the-cluster), and deploy your applications as you see fit.

### Mature/Advanced

If you're looking to the raw data as part of your deployments, follow these steps.

1. Use the [Deployment Helper](https://azure.github.io/Aks-Construction/) to guide your AKS configuration.
2. Capture the parameters on the *Template Parameters File* tab to a file - this is your configuration
3. Check the *Post Configuration* tab for any commands and save them to a file
4. Grab the [latest release](https://github.com/Azure/Aks-Construction/releases) of the bicep code
5. (optionally) Author an Application Main bicep to represent *your application* (see [here]([ABC-AKS/SampleAppMain.bicep at main · RTmtfiallos/ABC-AKS · GitHub](https://github.com/rtmtfiallos/ABC-AKS/blob/main/samples/SampleAppMain.bicep)) for an example)
6. In your CI/CD system, either using one of the GitHub Action Workflow files as a base, or by coding it yourself - initiate a deployment of the bicep code, using your parameter file
7. In your CI/CD system, deploy your application(s) to the AKS cluster

## Guiding Principals

The guiding principal we have with is to focus on the the *downstream use* of the the parameters (see [releases](https://github.com/Azure/Aks-Construction/releases)). As such, these are our specific practices.

1. Deploy all components through a single, modular, idempotent bicep template Converge on a single bicep template, which can easily be consumed as a module
2. Provide best-practice defaults, then use parameters for different environment deployments
3. Minimise "manual" steps for ease of automation
4. Maintain quality through validation & CI/CD pipelines that also serve as working samples/docs
5. Focus on AKS and supporting services, linking to other repos to solve; Demo apps / Developer workstations / Jumpboxes / CI Build Agents / Certificate Authorities
