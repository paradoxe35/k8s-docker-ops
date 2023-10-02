## Airflow

```bash
kubectl create namespace apache
helm repo add apache-airflow https://airflow.apache.org

helm upgrade --install --values values.yaml airflow apache-airflow/airflow -n apache
```