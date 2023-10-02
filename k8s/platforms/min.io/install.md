## Configure MinIO Helm repo

```bash
helm repo add minio https://charts.min.io/
```

Longhorn will be installed in the namespace `longhorn-system`.

## Install Prometheus

```bash
helm upgrade --install --values values.yaml minio minio/minio
```
