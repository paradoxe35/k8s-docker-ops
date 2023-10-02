## Cassadra

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install cassandra bitnami/cassandra \
      --set replicaCount=3 \
      --set cluster.seedCount=2 \
      --set dbUser.user=admin \
      --set dbUser.password=PASSWORD \
      --set cluster.minimumAvailable=2
```

## Kubeapps

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps

# Create namespace and credentials
kubectl create --namespace default serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: kubeapps-operator-token
  namespace: default
  annotations:
    kubernetes.io/service-account.name: kubeapps-operator
type: kubernetes.io/service-account-token
EOF


# Get app access token
kubectl get --namespace default secret kubeapps-operator-token -o go-template='{{.data.token | base64decode}}'

# Edit service/kubeapps and set the Service type to LoadBalancer
kubectl edit service/kubeapps -n kubeapps
```
