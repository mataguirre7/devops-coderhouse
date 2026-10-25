# DevOps Coderhouse - Proyecto Final

Pipeline DevOps completo para una aplicación web estática servida con Nginx.
El proyecto cubre: Docker, Terraform, CI/CD con GitHub Actions, Kubernetes,
monitoreo con Prometheus + Grafana y buenas prácticas de FinOps.

## Descripción del proyecto

La aplicación es una página web estática simple servida con Nginx dentro de un
contenedor. Alrededor de ella se armó toda la cadena de automatización típica de
DevOps para poder construirla, testearla, escanearla, desplegarla y monitorearla.

## Estructura del repositorio

```
.
├── index.html / css/          # La aplicación (sitio estático)
├── nginx.conf                 # Config de Nginx (puerto 8080 + /healthz)
├── Dockerfile                 # Imagen multi-stage
├── terraform/                 # Infraestructura (provider Docker + módulo de red)
├── k8s/                       # Manifiestos Kubernetes (deploy, svc, ingress, hpa)
├── monitoring/                # Prometheus + Grafana
├── finops/                    # Script y notas de optimización de costos
├── .github/workflows/         # Pipeline CI/CD
└── docs/INFORME.md            # Informe de la entrega
```

## Requisitos

- Docker
- Terraform >= 1.3 (opcional, para el provisioning local)
- kubectl + [kind](https://kind.sigs.k8s.io/) (opcional, para probar en Kubernetes)

## Ejecutar localmente

### Opción A: solo Docker

```bash
docker build -t devops-coderhouse:local .
docker run -d -p 8080:8080 devops-coderhouse:local
# Abrir http://localhost:8080
```

### Opción B: con Terraform (construye la imagen y levanta el contenedor)

```bash
cd terraform
terraform init
terraform apply -auto-approve
# Terraform muestra la URL en el output app_url (http://localhost:8080)
terraform destroy -auto-approve   # para limpiar
```

## Ejecutar en entorno de pruebas (Kubernetes con kind)

```bash
# 1. Crear el cluster local
kind create cluster --config k8s/kind-config.yaml

# 2. Instalar el Ingress controller (nginx)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# 3. Desplegar la aplicación
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml

# 4. Ver que esté todo arriba
kubectl get pods,svc,hpa -n nginx-app
```

Para entrar por el Ingress agregar `127.0.0.1 nginx-app.local` al archivo hosts
y abrir http://nginx-app.local

## Monitoreo (Prometheus + Grafana)

```bash
kubectl apply -f monitoring/namespace.yaml
kubectl apply -f monitoring/prometheus.yaml
kubectl apply -f monitoring/grafana.yaml

# Acceder a las UIs con port-forward:
kubectl port-forward -n monitoring svc/grafana 3000:3000     # http://localhost:3000 (admin/admin)
kubectl port-forward -n monitoring svc/prometheus 9090:9090  # http://localhost:9090
```

En Grafana el datasource de Prometheus ya viene configurado. Desde ahí se pueden
armar dashboards básicos (ej: estado de los targets, uso de CPU/memoria).

## Pipeline CI/CD

El workflow `.github/workflows/cicd.yaml` corre en cada push a `main` y hace:

1. **build-test** – valida el HTML, lintea el Dockerfile (hadolint), construye la
   imagen y hace un test de humo (`curl` a `/healthz` y a la página).
2. **sast** – escaneo de seguridad de la imagen con Trivy.
3. **build-push** – construye y publica la imagen en GitHub Container Registry
   (`ghcr.io/<usuario>/<repo>`).
4. **dast** – análisis dinámico con OWASP ZAP contra la app corriendo.
5. **deploy** – crea un cluster kind y aplica los manifiestos de Kubernetes.

> Las imágenes se publican en GHCR usando el `GITHUB_TOKEN` que ya provee Actions,
> no hace falta configurar secretos extra. Para desplegar en un cloud real se
> agregarían los secretos correspondientes (kubeconfig, credenciales, etc.).

## Validar el despliegue y el monitoreo

```bash
kubectl get pods -n nginx-app            # los pods deben estar Running
kubectl get hpa -n nginx-app             # el HPA debe mostrar métricas
curl http://localhost:8080/healthz       # responde "ok" (modo Docker)
```

Para el monitoreo, en Prometheus (http://localhost:9090) ir a *Status > Targets*
y verificar que los targets estén `UP`.

## FinOps

Ver [`finops/README.md`](finops/README.md). Resumen: HPA, requests/limits, imagen
liviana y un script `cleanup.sh` para apagar recursos cuando no se usan.

## Evidencias

Las capturas y logs que demuestran el funcionamiento (CI en verde, pods corriendo,
dashboard de Grafana, etc.) están en el informe: [`docs/INFORME.md`](docs/INFORME.md).
