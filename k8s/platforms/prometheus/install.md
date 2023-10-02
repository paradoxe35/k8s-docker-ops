## Install Longhorn

```bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml
```

Longhorn will be installed in the namespace `longhorn-system`.

## Install Prometheus

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install --values values.yaml prometheus prometheus-community/prometheus
```
