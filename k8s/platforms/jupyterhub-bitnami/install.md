## Install Jupyter

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install --values values.yaml  jupyterhub bitnami/jupyterhub --namespace jupyterhub-bitnami
```
