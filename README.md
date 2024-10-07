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

### Data Modeling on DBT
Move to direktori dags and create a folder name dbt
```
cd dags
mkdir dbt
cd dbt
```
After that Install using pip and virtual environments 
```
python3 -m venv dbt-venv   
```
Activate virtual environment
```
source dbt-venv/bin/activate
```

#### Install and Setup dbt
Install dbt-bigquery
```
pip install dbt-bigquery==1.8.2
```

Run dbt cli to init dbt with BigQuery as data platform
```
dbt init ecommerce_project
```

#### Setup `dbt_project.yml` configuration
```
models:
  ecommerce_project:
    # Config indicated by + and applies to all files under models/example/
    staging:
      +materialized: view
      +schema: staging
    intermediate:
      +materialized: table
      +schema: intermediate
    dimensional:
      +materialized: table
      +schema: dimensional
    fact:
      +materialized: table
      +schema: fact
    data_mart:
      +materialized: table
      +schema: data_mart
```

#### Setup DBT Profile
By default, DBT will create a dbt profile at your home directory ~/.dbt/profiles.yml You can update the profiles, or you can make a new dbt-profile directory. To make a new dbt-profie directory, you can invoke the following:
```
mkdir profiles
touch profiles/profiles.yml
export DBT_PROFILES_DIR=$(pwd)/profiles
```
Also, create a keyfile folder:
```
mkdir key_file
```
Then copy the service account JSON file and place it inside the key_file folder.

Set profiles.yml as follow:
```
ecommerce_project:
  outputs:
    dev:
      dataset: transformed_data
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: /usr/local/airflow/dags/dbt/ecommerce_project/key_file/farhan-project.json
      location: US
      method: service-account
      priority: interactive
      project: farhan-project-434204
      threads: 1
      type: bigquery
  target: dev
```
`Note` for the keyfile: make sure to match it with the name of your service account JSON file.

Defining Source and creating your a Model. you can copy all the folders [here](https://github.com/farhanriyandi/ELT-E-Commerce/tree/main/elt_project/dags/dbt/ecommerce_project/models) and paste it to your models folder.


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

Before running Airflow, by default airflow will run on localhost:8080, but we can set the port as desired. In the .astro folder, there is a file called config.yml. Here, I set the PostgreSQL port to 5435 and the Airflow port to 8089. So i have to use localhost:8089 to open airflow
```
project:
  name: elt-project
webserver:
  port: 8089
postgres:
  port: 5435
```

After that run
```
Astro dev start
```
In dbg dags folder add dbt_ecommerce_dag.py and add this code
```
import os
from datetime import datetime

from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import GoogleCloudServiceAccountDictProfileMapping



profile_config = ProfileConfig(
    profile_name="ecommerce_project",
    target_name="dev",
    profile_mapping=GoogleCloudServiceAccountDictProfileMapping(
        conn_id="bigquery_conn",
        profile_args={
            "project": "farhan-project-434204",  # Ganti dengan ID proyek BigQuery Anda
            "dataset": "my_e_commerce_dataset1",  # Ganti dengan nama dataset BigQuery Anda
            "keyfile": "/usr/local/airflow/dags/dbt/ecommerce_project/key_file/farhan-project.json" # ganti dengan file json anda
        },
    )
)

dbt_ecommerce_dag = DbtDag(
    project_config=ProjectConfig("/usr/local/airflow/dags/dbt/ecommerce_project"),
    operator_args={"install_deps": True},
    profile_config=profile_config,
    execution_config=ExecutionConfig(dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt",),
    schedule_interval="@daily",
    start_date=datetime(2024, 9, 9),
    catchup=False,
    dag_id="dbt_ecommerce",
)

dbt_ecommerce_dag
```

And then open localhost:8089 to access airflow. The username is admin and the password is admin. After that, click on Admin and then click on connections to create big querry connection.
![image](https://github.com/user-attachments/assets/114d74c7-f010-4962-b36e-e6d1afcfc3fe)

`Note` Copy the contents of the service account JSON file and paste them into the Keyfile JSON.



#### Trigger dag
You can trigger the DAG and monitor its progress in the Airflow UI.
![Screenshot 2024-10-07 132743](https://github.com/user-attachments/assets/e827a205-7c03-40fe-b2b7-5ad3731a1619)



  
