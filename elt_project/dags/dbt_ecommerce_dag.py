import os
from datetime import datetime

from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from pathlib import Path
from cosmos.profiles import GoogleCloudServiceAccountDictProfileMapping



profile_config = ProfileConfig(
    profile_name="ecommerce_project",
    target_name="dev",
    profile_mapping=GoogleCloudServiceAccountDictProfileMapping(
        conn_id="bigquery_conn",
        profile_args={
            "project": "farhan-project-434204",  # Ganti dengan ID proyek BigQuery Anda
            "dataset": "my_e_commerce_dataset1",  # Ganti dengan nama dataset BigQuery Anda
            "keyfile": "/usr/local/airflow/dags/dbt/ecommerce_project/key_file/farhan-project.json"
        },
    )
)
 # /usr/local/airflow/dags/dbt/ecommerce_projec/key_file/farhan-project-434204-7c30fa209b8e.json

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







