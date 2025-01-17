"""a DAG to sync data from Polygon API to BigQuery and run dbt daily."""

from datetime import datetime, timedelta
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow import DAG


# Airbyte connection IDs
AIRBYTE_CONNECTION_IDS = [
    '62e7fd0b-b075-40ec-b350-608a1b694711',
    'dd2d5539-6e30-4d91-9237-69a7df8bee07',
    '6bdf0d28-d0f9-48df-976d-59da73f710f3',
    '6f9ceb50-d7d8-4978-a2d7-43ba9b472b08',
    'aa031dd4-634d-47eb-9cdc-f339f8d8b8bb'
]
AIRBYTE_CONN_ID = 'airbyte_to_bigquery'

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'start_date': datetime(2023, 10, 1),
}

# Profile configuration for dbt
profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profiles_yml_filepath="/opt/airflow/dbt/profiles/profiles.yml",
)

# Define the DAG
with DAG(
    'PolygonAPI_to_BigQuery',
    default_args=default_args,
    description='A DAG to sync data from Polygon API to BigQuery and run dbt daily',
    schedule_interval="@daily",
    catchup=False,
) as dag:

    sync_tasks = []
    for i, connection_id in enumerate(AIRBYTE_CONNECTION_IDS):
        task = AirbyteTriggerSyncOperator(
            task_id=f"sync_data_connection_{i+1}",
            connection_id=connection_id,
            airbyte_conn_id=AIRBYTE_CONN_ID,
            asynchronous=False,
            timeout=3600,
            wait_seconds=3
        )
        sync_tasks.append(task)

    # dbt transformation task group
    dbt_transformation = DbtTaskGroup(
        group_id="dbt_transformation",
        project_config=ProjectConfig("/opt/airflow/dbt/dbt_stock_project"),
        profile_config=profile_config,
        execution_config=ExecutionConfig(
            dbt_executable_path="/home/airflow/.local/bin/dbt"
        )
    )

    # Set task dependencies
    sync_tasks >> dbt_transformation
