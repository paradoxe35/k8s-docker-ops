## Cassandra

```bash
kubectl create namespace apache
helm repo add bitnami https://charts.bitnami.com/bitnami

helm upgrade --install --values values.yaml cassandra bitnami/cassandra -n apache
```
