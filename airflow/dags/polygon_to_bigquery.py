from datetime import timedelta
from airflow.utils.dates import days_ago
from airflow import DAG
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator


AIRBYTE_CONNECTION_IDS = ['62e7fd0b-b075-40ec-b350-608a1b694711',
                         'dd2d5539-6e30-4d91-9237-69a7df8bee07',
                         '6bdf0d28-d0f9-48df-976d-59da73f710f3',
                         '6f9ceb50-d7d8-4978-a2d7-43ba9b472b08',
                         'aa031dd4-634d-47eb-9cdc-f339f8d8b8bb']
AIRBYTE_CONN_ID = 'airbyte_to_bigquery'

default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}


with DAG(
    'PolygonAPI_to_BigQuery',
    default_args=default_args,
    description='Sync Polygon data and additional connections to BigQuery daily',
    start_date=days_ago(1),
    schedule_interval='@daily',
    catchup=False,
) as dag:
    sync_tasks = []

    for i, connection_id in enumerate(AIRBYTE_CONNECTION_IDS):
        task = AirbyteTriggerSyncOperator(
            task_id=f"sync_data_connection_{i+1}",
            connection_id=connection_id,
            airbyte_conn_id=AIRBYTE_CONN_ID
        )
        sync_tasks.append(task)
