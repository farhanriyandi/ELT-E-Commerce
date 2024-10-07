# ELT-E-Commerce
In this project, we will engage in a comprehensive data engineering initiative. We will leverage a financial dataset from Kaggle to uncover valuable insights by analyzing trends and patterns within the data. The scope of the project includes the following tasks:

1. Uploading the CSV files from Kaggle to Google Cloud Storage.
2. Creating a dataset in BigQuery.
3. Transferring data from Google Cloud Storage to a raw format.
4. Transforming the data using DBT.

## Tools
* CSV (Data Source)
* BigQuery (Data Warehouse)
* Airflow (Orchestration)
* DBT (Transformation)

## Prerequisites
Before running the data pipeline, ensure you have the following prerequisites:

* Google Cloud Account.
* [Docker](https://www.docker.com/) is installed and running.
* [Astro CLI](https://www.astronomer.io/docs/astro/cli/overview)

## Getting Started

### Create an Astro project
```
Astro dev init
```

This command creates all the necessary project files for running Airflow locally, including pre-built example DAGs that you can execute immediately.

###  Create a Service Account and Assign Roles:
* Go to “IAM & Admin” > “Service accounts” in the Google Cloud Console.
* Click “Create Service Account”.
* Name your service account.
* Assign the “Owner” roles to the service account.
* Finish the creation process.
* Make a JSON key to let the service account sign in.
* Find the service account in the “Service accounts” list.
* Click on the service account name.
* In the “Keys” section, click “Add Key” and pick JSON.
* The key will download automatically. Keep it safe and don’t share it.



### Run Airflow locally
Before you run Airflow locally you need to add the following command to the dockerfile.
```
FROM quay.io/astronomer/astro-runtime:12.1.1

RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-bigquery google-cloud-bigquery && deactivate
```

And you need to add following to the requirements.txt
```
astronomer-cosmos
apache-airflow-providers-google
```


  
