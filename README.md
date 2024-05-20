# MuleSoft Accelerator API Template

This Mule project provides some generic flows and global configurations to be
used as a starting point for creating API implementations. This includes 
property file configurations, both for running locally and for deployment to 
a development environment; support for secured properties; a simple API
interface and implementation, with an HTTP listener and router kit 
configuration; a sample back-end HTTP request configuration; and some basic 
MUnit testing.

## Description

The template implements the following aspects of a Mule API application:

* Standard project structure and naming conventions for Production-ready APIs
* Use of a well-designed parent POM for streamlined Maven configuration
* Recommended configurations for properties files
* Typical API implementation (API Autodiscovery, HTTP Listener, and APIKit Router)
* MUnit testing

Note that the Autodiscovery element is commented out by default.

## Prerequisites

The following software is required in order to build and run this template:

* Oracle Java Development Kit (JDK) 1.8
* Apache Maven 3.9.6 or later
* Anypoint Studio 7.16.x or later
* A properly-configured `settings.xml` for accelerator builds 

Refer to the [Getting Started](https://docs.mulesoft.com/accelerators-home/getting-started) guide
for more details on configuring your local workstation for development.

## Getting started

Download the template source from Anypoint Exchange, extract the contents,
and copy the project to the desired workspace. Import the project and 
rename it to match the target API being implemented. Add the API RAML or OAS
specification as an Exchange dependency and scaffold the implementation. The 
original `api-template.xml` and `resource.xml` files can be removed or used as
reference. In the generated main file, remove any global configuration
elements.

## Customizing the template

The template is designed to be customized. Some basic customization should be 
done every time the template is used for implementing a new API. 

### Basic customization

The steps below detail the actions to take in order to customize the template 
after it is imported into Anypoint Studio.

1. Rename the Anypoint Studio project folder to the actual name of your API. 
To rename the project, right-click on the project root folder in the 
Package Explorer view, select **Refactor -> Rename**, type the name of 
your new project, and click **OK** to confirm.

1. Open the `pom.xml` file in the project and update it with  
the actual Maven artifact's coordinates. **Update `<groupId>`** with the 
target package name and **change `<artifactId>`** to match the 
project name that has been set in the step above. Save the file and let 
Anypoint Studio rebuild the project.

1. **Update the `log4j2.xml`** file under `src/main/resources` and rename
all occurrences of `api-template` in the `<RollingFile>` element with the 
project name. Leave the remaining parts of the file unchanged for now.

1. **Change the `ENV_PROFILE`** in deploy scripts under project home folder
based on the profile(s) that you want to use for packaging and deploying the 
apps to Cloudhub. The `ENV_PROFILE` is defaulted to `CloudHub-DEV,CloudHub-BASE,CloudHub-APP` 
and it needs to be changed in `deployOnly.cmd`, `deployOnly.sh`, `packageDeploy.cmd`
and `packageDeploy.sh` files. 

The `CloudHub-DEV` profile is expected to be in `settings.xml`, and defines
configuration properties and hidden (secure) settings common to all application 
deployments. The `CloudHub-BASE` profile, provided by the parent POM, defines 
the basic configuration for deploying to CloudHub 1.0, while the `CloudHub-APP`
profile defined in the actual application's Maven config provides additional
overrides specific to the application. 

### Properties configuration

This template comes with a default configuration that supports properties 
files. The Property Placeholder is contained in the `global.xml` file under
the `src/main/mule` folder. The template uses profiles to load the appropriate 
properties file: `config-local.yaml` or `config-dev.yaml` for non-secured 
properties, such URLs, ports, timeouts, polling intervals or anything else 
that can be used to configure the behavior of the application. The
`config-secured-local.yaml` and `config-secured-dev.yaml` files are used for
sensitive data, such as passwords or access keys/credentials, which must
not be exposed as unencrypted text. Properties that are not environment-
specific are defined in the `config.yaml` file.

### CloudHub deployment

When the application is deployed to CloudHub, the environment is specified in
the appropriate deployment profile defined in the `settings.xml` file. Any 
sensitive application properties can also be specified there. These "hidden
properties" are injected at deployment time by adding them to the configuration 
of the [Mule Maven Plugin](https://docs.mulesoft.com/mule-runtime/4.4/mmp-concept),
as follows:

```xml
<plugin>
    <groupId>org.mule.tools.maven</groupId>
    <artifactId>mule-maven-plugin</artifactId>
    <extensions>true</extensions>
    <configuration>
        <cloudHubDeployment>
            <properties>
                <app.password>${my.app.password}</app.password>
            </properties>
        </cloudHubDeployment>
    </configuration>
</plugin>
```

### Local deployment

The default setting for `mule.env` in `global.xml` is for running the
application from within Studio. Any properties that are overridden at
deployment time (i.e., those defined in the `cloudHubDeployment` section of
the application's pom.xml file) must be added as VM arguments to your 
Run/Debug configuration before launching.

### API Listener

This template provides a pre-built API Listener configuration, including an 
HTTP Listener and an APIKit Router pointing to a local RAML file 
(`api-template.raml`), which is located under the `src/main/api` folder. 

The template is also configured with an API Autodiscovery global element, 
disabled by default, which is responsible for registering the API in the 
API Manager. Once the API autodiscovery element has been enabled, it can
be configured via the property shown here:
 
```
# API Configuration
api-template:
  http-listener:
    autodiscovery-id: "99999999"
```

#### HTTP Listener

The HTTP Listener can also be configured via the properties file. It is 
possible to change **host**, **port**, and **base path** on which the API is 
listening. The default configuration for the API HTTP Listener provided in this 
template is shown below; the values should be updated according to your specific 
needs.

```
# API Configuration
api-template:
  http-listener:
    host: "0.0.0.0"
    port: "8081"
    path: "/api/*"
```

Note that the `path` property shown above is actually defined in the common 
properties file, which is not environment-specific.

### APIKit Router

By default the APIKit Router is pointing to  `accelerator-mulesoft-api-template`,
which defines a simple API specification. This should be replaced with an 
Exchange dependency for the target API actually being implemented. 

To replace the RAML file, right-click on the project and select 
`Manage Dependencies -> Manage APIs`. Add the desired dependency and choose 
the option to scaffold the API when prompted. This will generate the skeletons 
of the operations that need to be implemented according to the resources 
specified in the new RAML file.

The skeletons of the flows can be edited in the `api.xml` configuration file, 
which is placed in the `src/main/mule` folder.
