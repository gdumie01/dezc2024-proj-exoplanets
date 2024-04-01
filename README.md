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
* Cloud: Google Cloud Platform
  * Data Lake - Google Cloud Storage
  * Data Warehouse: BigQuery
* Infrastructure as Code (IaC): Terraform
* Data ingestion (Batch/Workflow Orchestration): Mage
* Data Transformation: dbt
* Data Visualization: Looker Studio

