# pmm-client-alpine
Running pmm-client with alpine version in Kubernates

## Build Docker Image
docker build -f Dockerfile -t pmm-client:2.0 --no-cache --squash .

## Get pods
kubectl get pods --namespace=[NAMESPACE]

## Remote pods
kubectl --namespace=[NAMESPACE] exec [PODS-NAME] -i -t -- sh -il

## Add linux matrics
pmm-admin add linux:metrics

## Add proxysql matrics
pmm-admin add proxysql:metrics --dsn "[USERNAME]:[PASSWORD]@tcp([IP-PROXYSQL]:6032)/" [PROXYSQL-NAME]
