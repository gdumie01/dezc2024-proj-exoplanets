# Exoplanets | Final project for Data Engineering Zoomcap 2024

This repository contains the code and materials for the final project of the [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)  in the 2024 Cohort. 

The project focuses on building an end-to-end data pipeline from [NASA's exoplanet archive](https://exoplanetarchive.ipac.caltech.edu/cgi-bin/TblView/nph-tblView?app=ExoTbls&config=PS) all the way up to the datasets that feed the final [dashboard](https://lookerstudio.google.com/reporting/48002710-b1bd-42cf-b4a2-61cc555a3f8c):

<table><tr>
<td> <img src="images/pipeline.png"/> </td>
<td> <img src="images/dbt-lineage.png"/> </td>
 <td> <img src="images/dashboard.png"/> </td>
</tr>
<tr>
<td>Mage Pipeline DAG</td>
<td>DBT model lineage Graph</td>
<td>Looker Dashboard</td>
</tr></table>

## Table of Contents
* [Project Description](#project-description)
* [Project Setup](#project-setup)
* [Visualizing the results](#visualizing-the-results)
* [Evaluation Criteria](#evaluation-criteria)

## Project description

### Problem description

Space was always something that has fascinated me. More recently I have been an avid follower of the [Astrum](https://www.youtube.com/@astrumspace) youtube channel where the creator exposes several exciting astronomy topics in layman's terms. While watching the videos, I have felt the need to have a more structured notion of what exactly we know and don't know about the universe, in particular the planets outside our solar system (exoplanets). Luckily I've found [NASA's exoplanet archive](https://exoplanetarchive.ipac.caltech.edu/index.html) in the dataset lists for the Data Engineering Zoomcamp and decided to navigate thru the data to understand:
* Exactly how many planets have we discovered so far
* How have we discovered them and what are the most relevant techniques
* From all the planets that we have found, which ones could be potentially habitable taking into account:
  * The distance to their host star and whether they fall into what astronomers call the goldilock zone which could sustain materials such as water or methane at liquid temperatures
  * The estimated surface gravity - as we know if the gravity is too high or too low our bodies would collapse.

There are of course many other factors to take into account before packing and move into another exoplanet (radiation, atmosphere composition, planet constitution whether solid or gas, etc), but let's bear with just these for the purpose of the exercise.

NOTE: I don't have any background in astronomy or astrophysic - so if you are a professional scientist reading this, please allow for some gross simplfications, this is just a Data Engineering project :wink:

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
* `exo-planets-pipeline`: With all the code with for orchestration pipeline, including dbt models under `exo-planets-pipeline/dbt` (which can be added as a dbt sub-directory in dbt cloud)
* `dashboard`: Report export from Looker Studio
* `images`: Printouts of results
* `mage_data/exo-planets-pipeline`: contains the mage db to allow for the the automatic API call on docker compose up

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

### Seting up the project

*Note: these instructions are used for macOS/Linux/WSL, for Windows it may differ*

1. Clone this repository
```bash
git clone https://github.com/gdumie01/dezc2024-proj-exoplanets.git
```
2. Enter its root directory:
```bash
cd dezc2024-proj-exoplanets
```
3. Setup a new GCP project

* Start by creating a GCP account at [this link](https://cloud.google.com/) (although GCP account can be created for free on trial but would still require a credit card to signup)
* Navigate to the GCP Console and create a new project. Give the project an appropriate name and take note of the `Project ID`.
* Create a service account:
  * In the left sidebar, click on "IAM & Admin" and then click on "Service accounts."
  * Click on the "Create service account" button at the top of the page.
  * Enter a name for your service account and a description (optional).
  * Add the roles `BigQuery Admin` and `Storage Admin` to the service account.
  * Click "Create" to create the service account.
  * After you've created the service account, you need to download its private key file.
    * Click on the service account you just created to view its details.
    * Click on the "Keys" tab and then click the "Add Key" button.
    * Select the "JSON" key type and click "Create" to download the private key file.
    * Store the json key as you please, but then copy it into the `root` directory of this project and give it exactly the name `keys.json`.

#### Running Terraform

4. Edit terraform **variables.tf** file.
You need to change the variable `project` to the `Project ID` of the GCP project you've just created and give a bucket name to `data-lake-bucket` to something that doesn't clash with existing buckets (e.g.: add a number to the end)

![Terraform](https://github.com/gdumie01/dezc2024-proj-exoplanets/blob/main/images/terraform-vars.png)

My resources are created for region **EU**. If needed, you can change it in **variables.tf** file - make sure you change it accordingly in the following steps, specially in dbt.

5. Prepare working directory for following commands:
```bash
terraform init
```
6. Check execution plan:
```bash
terraform plan
```
7. Create the infrastructure:
```bash
terraform apply
```
When you are done with the project, you can release all resources by running `terraform destroy`.

#### Executing Mage Pipeline
8. Rename `dev.env` to simply `.env`.
```bash
mv dev.env .env
```
9. Edit the .env file with the same `Project ID` and bucket name you just configure in Terraform
```
PROJECT_NAME=exo-planets-pipeline
GCP_PROJECT_NAME=<YOUR PROJECT ID>
BUCKET_NAME=<YOUR BUCKET NAME>
```
10. Build the Mage containter
```bash
docker compose build
```
11. Start the Docker container:
```bash
docker compose up
```
12. Once the docker container is running navigate to (http://localhost:6789/pipelines/nasa_exoplanets_to_gcs/triggers) in your browser

13. To your ease, I have created a service in the docker compose that triggers a pipeline execution when you `run docker compose up`, so once the page is loaded you should already see an execution running. If for some reason it didn't work, or if you need to, you can always click on Run@once.
<table><tr>
<td> <img src="images/run.png"/> </td>
<td> <img src="images/config_variables.png"/> </td>
<tr>
<td>Click Run@once</td>
<td>Specify variables</td>
</tr>
</tr></table>

After it runs, you will have:
* A parquet file in the datalake
* the `dw_exo_planets` dataset in BigQuery with the following tables and views:

![Outputs](https://github.com/gdumie01/dezc2024-proj-exoplanets/blob/main/images/dw-outputs.png)

14. In case you forgot or mistakenly set the .env variables you can alway fire up a terminal and terminate the mage container
    
```bash
docker compose down
```
And restart from whatever step you want in order to retry.

#### Replicating the dashboard
12. To replicate the dashboard, simply go to the [dashboard](https://lookerstudio.google.com/reporting/48002710-b1bd-42cf-b4a2-61cc555a3f8c) URL, click on the *more options* icon at the top right end of the screen and select `Make a copy`
13. Then simply point the datasources to the newly created tables within your project `fact_discovery` and `fact_habitability`

![CopyReport](https://github.com/gdumie01/dezc2024-proj-exoplanets/blob/main/images/copy-report.png)

## Visualizing the results
I have publishing the following [dashboard](https://lookerstudio.google.com/reporting/48002710-b1bd-42cf-b4a2-61cc555a3f8c) to exhibit the results of the final datasets.

![Dashboard](https://github.com/gdumie01/dezc2024-proj-exoplanets/blob/main/images/dashboard.png)

Key insights for me were:
* 2013 and 2016 really helped on the advancement of our knowledge about exoplanets - 40% of all know planets were discovered in those years.
* Instruments in space are key to help us discover new planets, although since 2016 ground facilities have also seen their contribution weight increase on the discovery of new planets
* Transit is by far the most used discovery method technique
* Despite all this, for 77% of the discovered planets we are missing key information that would enable us to understand where they are located within their solar systems and their mass which could help us understand what type of planets they are

**In conclusion**: despite the rapid recent advacements of science, we are still a long way to be sure about habitability of exoplanets by humans.

## Evaluation Criteria

I aimed to hit the following evaluation criteria:
- :white_check_mark: **Problem description**: Hope the contents of this readme are enough to understand my motivations and the problem I was trying to address with this project.
- :white_check_mark: **Cloud**: The project is developed on the cloud (Google) and IaC tools (Terraform) are used for provisioning the infrastructure.
- :white_check_mark: **Data Ingestion**: Fully deployed workflow orchestration using Mage from API to consumable analytics layer.
- :white_check_mark: **Data warehouse**: Tables are created in BigQuery and optimized for the upstream queries based on clustering and partition (see comments in the code).
- :white_check_mark: **Transformations**: Tables are transformed using dbt, including calculation of surface gravity and computation of planet type according to some rules.
- :white_check_mark: **Dashboard**: 2 tiles were created - one linked to distribution of the data across a temporal line (evolution of planet discoveries) and another with categories generated based on planet's data.
- :white_check_mark: **Reproducibility**: Hopefully it works when you follow the instructions :smile:.
