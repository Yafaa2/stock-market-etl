FROM apache/airflow:2.7.0-python3.8

USER airflow

# Install specific versions of Airflow and providers
RUN pip install --user \
    apache-airflow==2.7.0 \
    apache-airflow-providers-airbyte[http] \
    astronomer-cosmos \
    apache-airflow-providers-openlineage>=1.8.0 \
    dbt-core \
    dbt-bigquery

# Add dbt to PATH
ENV PATH="/home/airflow/.local/bin:${PATH}"