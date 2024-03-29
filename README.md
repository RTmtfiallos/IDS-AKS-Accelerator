<img align="left" width="100" height="100" src="https://docs.microsoft.com/answers/topics/25346/icon.html?t=168484">

# IDS AKS Accelerator

It can be extremel y challenging to design and deploy a Kubernetes cluster that is Enterprise ready. You have to deal with complex ARM Templates, syntax errors, and potentially hundreds of parameters. The entire deployment can fail if one of them is wrong, leaving partially deployed resources to clean up. Time is wasted, leading to frustration.

## How Randstad helped ACME LLC

The Randstad IDS Cloud Practice developed a simple, secure, lightweight, and flexible solution to streamline AKS configuration and deployment..

### Critical requirements and success factors

* User-friendly and easy to understand
* Delivers repeatable results and predictable infrastructure
* Provides flexible configuration options that can be easily modified to incorporate future features, patterns, or frameworks
* sjadjhasdjhasjd
* kasdkaskjdasjkda
* Reduce post-deployment AKS configuration requirements
* Fully automated, includes testing, and is efficient and streamlined.

### Guiding Principals

## The focus is on the downstream application of the parameters. "Shift Left" - Integrate security and compliance earlier into IaC & CI/CD pipelines. Our specific practices are as follows:

1. All components should be deployed through a single, modular, idempotent bicep template
2. Converge on a bicep template that can be easily consumed as a module
3. Provide bes[t-practice defaults, then use parameters based on](https://google.com) the deployment environment
4. Automate as many "manual" steps as possible
5. Ensure quality through pre-validation, regression tests, and continuous integration and delivery pipelines
6. Concentrate on AKS and supporting services, linking to other repositories to address Demo apps, Developer workstations, Jumpboxes, CI Build Agents, Certificate Authorities, etc.

### Reference architectures, baselines, frameworks, and best practices

The Randstad team leveraged and incorporated numerous architectural approaches, frameworks, best practices, and security controls to design and deploy an Enterprise-Ready AKS cluster.

* [AzOps-Accelerator](https://github.com/RTmtfiallos/AzOps-Accelerator)

  * Used in Azure DevOps and GitHub to baseline, pull, push, & validate Azure resources such as policyDefinitions, policyAssignments and roleAssignments.
    <BR>
* [AKS Secure Baseline {Private Cluster}](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks)

  * The AKS bicep code is based on the architecture of the AKS Baseline, the Well Architected Framework. Randstad has highly customized the solution to ensure successful implementations with a high degree of confidence. The result is a fully validated infrastructure before it's deployed.
  * To "Shift Left" as much as possible, ensuring AKS is well-architected and secure.
  * Although the code and configuration for this project are largely based on the AKS Baseline, the philosophy is different.
  * For this client and project, we are focusing on the [implementation experience](https://rtmtfiallos.github.io/IDS-AKS-Accelerator/helper/public/) and [automation workflows](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/tree/main/.github/workflows). The AKS Baseline contains much of the documentation and practices.
    <BR>
* [Well Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/)

  * Microsoft's Azure Well-Architected Framework outlines guiding principles for improving the quality of workloads. It consists of five pillars of architectural excellence:

    * Reliability
    * Security
    * Cost Optimization
    * Operational Excellence
    * Performance Efficiency

  <BR>

<img src="https://github.com/RTmtfiallos/IDS-AKS-Accelerator/blob/main/assets/20220216_101620_waf-diagram-revised.png?raw=true">

* At its center is the Well-Architected Framework, which includes the five pillars of architectural excellence. The framework is complemented by six supporting elements.

  * Azure Well-Architected Review
  * Azure Advisor
  * Documentation
  * Partners, Support, and Services Offers
  * Reference Architectures
  * Design Principles

<P></P>

* [Cloud Adoption Framework](https://azure.microsoft.com/en-gb/cloud-adoption-framework/)

  * The Cloud Adoption Framework is a collection of documentation, implementation guidance, best practices, and tools that are proven guidance from Microsoft designed to accelerate your cloud adoption journey.
    <BR>
* [PSRule for Azure Reference](https://azure.github.io/PSRule.Rules.Azure/en/rules/module/)

  * PSRule for Azure includes over 250 rules for validating resources against configuration recommendations.
    Rules automatically detect and analyze resources from Azure IaC artifacts.
  * Pre-flight validation can be integrated into a continuous integration (CI) pipeline as unit tests to:
    * "Shift-left" — Identify configuration issues and provide fast feedback in PRs.
    * Quality gates — Implement quality gates between environments such as development, test, and production.
    * Monitor continuously — Perform ongoing checks for configuration optimization opportunities.

<P></P>

* [Enterprise-Scale](https://github.com/Azure/Enterprise-Scale)

  * Enterprise Scale provides prescriptive guidance based on authoritative design for the Azure platform as a whole.
  * The [RT AKS Deployment Helper](https://rtmtfiallos.github.io/IDS-AKS-Accelerator/helper/public/) has an Enterprise-Scale lens, with preset configurations for each landing zone area.

<P></P>

* [Enterprise Scale for AKS](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/aks/enterprise-scale-landing-zone/)

  * The reference implementations in this repository are all focussed on guiding the creation of Landing Zones for AKS within an Enterprise Scale framework. They typically include deployments of Hub/Spoke infrastructure and development vm's, and includes a Terraform implementation.

<P></P>

* [Azure Policy for AKS](https://docs.microsoft.com/en-us/azure/aks/policy-reference)

  * Built-in policy definitions for Azure Kubernetes Service

<BR>

As a result, ABC is able to quickly deploy the Azure Kubernetes Service as well as container workloads, using tested/proven best practices and a flexible templating approach to address differing business and IT requirements.

<BR>

## The 3 Main Components & Building Blocks for the solution

<img  src="https://raw.githubusercontent.com/RTmtfiallos/IDS-AKS-Accelerator/main/docassets/AKSBicepComponents.png">

### Wizard experience

To help guide ABC's initial AKS configuration and fully automate the deployment of the Dev & Production ABC AKS clusters, use the developed and highly customizeable [RT AKS Deployment Helper](https://rtmtfiallos.github.io/IDS-AKS-Accelerator/helper/public/).

The AKS Deployment helper will provide a set of parameters and scripts to make deployment simple and fully automated. It uses several preset configurations, patterns, and building blocks to guide configuration decisions.

If requirements change, or if there is a need for another AKS Cluster you can simply create a new set of deployment files to use whenever needed.

We've broken it down to 2 sets of principles to help balance flexibility, function, and costs; **Operations & Security Principles.**

<BR>

![](assets/20220209_210726_helper1.png)

![](assets/20220216_082814_securityprin.png)

The deployment helper provides links to the official Microsoft documentation to help provide additional context for each feature.

### IaC - Bicep code files

IaC (Infrastructure as Code) code files have been modularised into their component areas. [Main.bicep](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/blob/main/bicep/main.bicep) references them and they are expected to be present in the same directory. The Deployment Helper leverages an Arm json compiled version of all the bicep files.

### DevOps - GitHub Actions

A number of [GitHub actions](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/actions) are used in the repo that run on push/pr/schedules. These can be copied into your own repo and customised for your CI/CD pipeline. A robust deployment pipeline is essential when coordinating the deployment of multiple Azure services that work together, additionally there is configuration that cannot be set in the template and that needs to be automated (and tested) consistently.

![preview screenshot of the helper wizard](docassets/ghactionworkflow.jpg)


| CI Name         | Actions Workflow                                                                                                            | Parameter file                                                                                                                                       | CI Status | Notes                                                                                |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- | -------------------------------------------------------------------------------------- |
| Starter cluster | [StandardCI.yml](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/blob/main/.github/workflows/StandardCI.yml)             | [ESLZ Sandbox](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/blob/main/.github/workflows_dep/AksDeploy-Basic.parameters.json)                   |           | A simple deployment example, good for first time users of this project to start with |
| BYO Vnet        | [ByoVnetCI.yml](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/blob/main/.github/workflows/ByoVnetCI.yml)               | [ESLZ Byo peered vnet](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/blob/main/.github/workflows_dep/AksDeployByoVnet.parameters.jso)           |           | Comprehensive IaC flow deploying multiple smoke-test apps                            |
| Private cluster | [ByoVnetPrivateCI.yml](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/blob/main/.github/workflows/ByoVnetPrivateCI.yml) | [ESLZ Byo private vnet](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/blob/main/.github/workflows_dep/AksDeploy-ByoVnetPrivate.parameters.json) |           | As above, but with a focus on private networking                                     |

For a more in depth look at the GitHub Actions created, which steps are performed and the different CI practices they demonstrate, please refer to [this page](GhActions.md).

<BR>

## Getting Started

### Basic

If this is the first time you are working with Bicep files, follow these steps.

1. Use the [Deployment Helper](https://rtmtfiallos.github.io/IDS-AKS-Accelerator/helper/public/) to guide your AKS configuration.
2. Run the commands in the*Provision Environment* tab to create your AKS Environment in your Azure subscription
3. Run the commands in the*Post Configuration* tab to complete your implementation
4. [Connect to your AKS Cluster](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough#connect-to-the-cluster), and deploy your applications as you see fit.

### Mature/Advanced

If you're looking to the raw data as part of your deployments, follow these steps.

1. Use the [Deployment Helper](https://rtmtfiallos.github.io/IDS-AKS-Accelerator/helper/public/) to guide your AKS configuration.
2. Capture the parameters on the*Template Parameters File* tab to a file - this is your configuration
3. Check the *Post Configuration* tab for any commands and save them to a file
4. Grab the [latest release](https://github.com/Azure/Aks-Construction/releases) of the bicep code
5. (optionally) Author an Application Main bicep to represent*your application* (see [here](https://github.com/RTmtfiallos/IDS-AKS-Accelerator/blob/main/bicep/samples/SampleAppMain.bicep) for an example)
6. In your CI/CD system, either using one of the GitHub Action Workflow files as a base, or by coding it yourself - initiate a deployment of the bicep code, using your parameter file
7. In your CI/CD system, deploy your application(s) to the AKS cluster

## Deviations from the baseline (and why)

1. System pool and user pool separation is made optional in interests of users seeking a cost optimised configuration.
2. Ingress. Supports no ingress, [AGIC](https://azure.github.io/application-gateway-kubernetes-ingress/) integrated experience or post deployment ingress scripts for [NGINX](https://docs.nginx.com/nginx-ingress-controller/) and [Contour](https://github.com/projectcontour/contour).
3. Networking. Hub/Spoke networks typically already exist, and tightly bundling with Kubernetes doesn't work well here. BYO subnets are supported.
4. AppGw Public Listener. AppGw is the WAF ingress point for inbound internet traffic, however private listeners are also valid for fully private environments.
5. Cluster SLA. Is defaulted to off in interests of a more cost optimised default configuration, a parameter can be provided to opt in for the paid SLA.
6. Monitoring Alerts. Parametrised metric analysis frequency, created two presets (1 as per baseline, 2 less frequent), set default to be much less frequent. Added extra monitoring alerts as per in-cluster suggestions.
