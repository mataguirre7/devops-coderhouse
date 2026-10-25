#!/usr/bin/env bash
# FinOps: apagar recursos que no se estan usando para no gastar de mas.
# Pensado para correr al final del dia o cuando no se necesita el entorno de pruebas.
set -e

echo ">> Escalando la app a 0 replicas (deja de consumir CPU/memoria)..."
kubectl scale deployment/nginx-app -n nginx-app --replicas=0 || true

echo ">> Apagando monitoreo (Prometheus + Grafana)..."
kubectl scale deployment/prometheus -n monitoring --replicas=0 || true
kubectl scale deployment/grafana -n monitoring --replicas=0 || true

# Si se usa el cluster local de kind, se puede borrar entero para no dejar nada corriendo:
# kind delete cluster

# Si se uso Terraform (docker local), para destruir los recursos:
# cd terraform && terraform destroy -auto-approve

echo ">> Listo. Recursos apagados."
