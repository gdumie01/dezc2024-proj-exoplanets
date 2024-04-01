# Exoplanets | Final project for Data Engineering Zoomcap 2024

This repository contains the code and materials for the final project of the Data Engineering Zoomcamp  in the 2024 Cohort. 

The project focuses on building an end-to-end data pipeline from [NASA's exoplanet archive](https://exoplanetarchive.ipac.caltech.edu/index.html) all the way up to the datasets that feed the following [dashboard](https://lookerstudio.google.com/reporting/48002710-b1bd-42cf-b4a2-61cc555a3f8c):

![Dashboard](https://github.com/gdumie01/dezc2024-proj-exoplanets/blob/main/images/dashboard.png)

## Project description

### Problem description

Space is always something that has fascinated me. More recently I have been an avid follower of the [Astrum](https://www.youtube.com/@astrumspace) youtube channel where the creator exposes several exciting astronomy topics for non-astroscientist. While watching the videos, I have also felt the need to have a more structured notion about what exactly what we know and don't know about the universe, in particular the planets outside our solar system (exoplanets). Luckily I've found [NASA's exoplanet archive](https://exoplanetarchive.ipac.caltech.edu/index.html) in the dataset lists for the Data Engineering Zoomcamp and decided to navigate thru the data to understand:
* Exactly how many planets have we discovered so far
* How have we discovered them and what are the most relevant techniques
* From all the planets that we have found, which ones could be potentially habitable taking into account:
  * The distance to their host star and whether they fall into what astronomers call the goldilock zone which could sustain materials such as water or methane at liquid temperatures
  * The estimated surface gravity - as we know if the gravity is too high or too low our bodies would collapse.

There are of course many other factors to take into account before packing and move into another exoplanet (radiation, atmosphere composition, planet constitution whether solid or gas, etc), but let's bear with just these for the purpose of the exercise.

NOTE: I don't have any background in astronomy or astrophysic - so if you are a professional scientist reading this, please allow for some gross simplfications, this is just a Data Engineering project ;)

### Pipeline description
#### Tech Stack
* Cloud: **Google Cloud Platform**
  * Data Lake: **Google Cloud Storage**
  * Data Warehouse: **BigQuery**
* Infrastructure as Code (IaC): **Terraform**
* Data ingestion (Batch/Workflow Orchestration): **Mage**
* Data Transformation: **dbt**
* Data Visualization: **Looker Studio**

#### Project Structure
The project has been structured with the following folders and files:
* `mage`: Workflow orchestration pipeline
* `dbt`: Data transformation logic
* `looker`: Report from Looker Studio
* `terraform`: IaC stream-based pipeline infrastructure in GCP using Terraform
* `images`: Printouts of results

#### High level overview:
* Pipeline fetches selected data [columns](https://exoplanetarchive.ipac.caltech.edu/docs/API_PS_columns.html) from the data from NASA's [API](https://exoplanetarchive.ipac.caltech.edu/docs/TAP/usingTAP.html#PS)
* Then it transforms data set (date fields) and uploads them to Google Cloud Storage.
* It then proceeds on to creating optimized (via clustering and partioning) and non-optimized raw versions of the data in the DataWarehouse.
* Once the data is in BigQuery, several steps are perfomed using dbt (including generating ids, calculating some parameters like gravity surface) to have the final clean dataset again in BigQuery ready for visualization.

## Project Setup
### Prerequisites
1. [Docker](https://docs.docker.com/engine/install/)
2. [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
3. [Terraform](https://developer.hashicorp.com/terraform/install)
4. Setup a GCP account
5. [dbt](https://cloud.getdbt.com/) account and project

Before running the code you need to follow the steps below.

#### Setting up GCP
Google Cloud is a suite of Cloud Computing services offered by Google that provides various services like compute, storage, networking, and many more. It is organised into Regions and Zones.

Setting up GCP would require a GCP account. A GCP account can be created for free on trial but would still require a credit card to signup.

1. Start by creating a GCP account at [this link](https://cloud.google.com/)
2. Navigate to the GCP Console and create a new project. Give the project an appropriate name and take note of the project ID.
3. Create a service account:
   - In the left sidebar, click on "IAM & Admin" and then click on "Service accounts."
   - Click the "Create service account" button at the top of the page.
   - Enter a name for your service account and a description (optional).
   - Select the roles you want to grant to the service account. For this project, select the BigQuery Admin and Storage Admin.
   - Click "Create" to create the service account.
   - After you've created the service account, you need to download its private key file. This key file will be used to authenticate requests to GCP services.
   - Click on the service account you just created to view its details.
   - Click on the "Keys" tab and then click the "Add Key" button.
   - Select the "JSON" key type and click "Create" to download the private key file. This key would be used to interact to the google API from Mage.
   - Store the json key as you please, but then copy it into the `mage` directory of this project  and
give it exactly the name `keys.json`.
