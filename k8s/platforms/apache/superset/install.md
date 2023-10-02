## Apache Superset

```bash
kubectl create namespace apache
helm repo add superset https://apache.github.io/superset

helm upgrade --install --values values.yaml superset superset/superset -n apache
```