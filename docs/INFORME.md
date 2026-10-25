# Informe - Proyecto Final DevOps

**Alumno:** Aguirre
**Curso:** DevOps - Coderhouse
**Repositorio:** https://github.com/mataguirre7/devops-coderhouse

> Documento para presentar como `PF_AGUIRRE.pdf` (exportar este markdown a PDF o
> pegarlo en Google Docs). Reemplazar los bloques `[CAPTURA: ...]` por las imágenes
> reales antes de entregar.

---

## 1. Objetivo

Construir un pipeline DevOps completo para una aplicación web estática servida con
Nginx, integrando Docker, Terraform, CI/CD, Kubernetes, monitoreo y FinOps.

## 2. Pasos realizados

### 2.1 Aplicación y Docker
- Página estática (`index.html` + `css/`).
- `Dockerfile` **multi-stage**: una etapa de build que prepara los archivos y una
  etapa final liviana basada en `nginx:alpine`.
- Nginx configurado en el puerto 8080 con un endpoint `/healthz` para los probes.

[CAPTURA: `docker build` + `docker run` y la página en el navegador]

### 2.2 Infraestructura con Terraform
- Provider Docker, con **variables** (`variables.tf`) y un **módulo** de red
  (`modules/network`).
- Crea una red Docker + el contenedor de la app (reproduce "redes" e "instancias").
- Comandos: `terraform init` / `apply` / `destroy`.

[CAPTURA: salida de `terraform apply` con el output `app_url`]

### 2.3 Pipeline CI/CD (GitHub Actions)
Workflow `.github/workflows/cicd.yaml` con los jobs:
1. build-test (lint + build + test de humo)
2. sast (Trivy)
3. build-push (publica la imagen en GHCR)
4. dast (OWASP ZAP)
5. deploy (cluster kind + manifiestos)

[CAPTURA: workflow en verde en la pestaña Actions]

### 2.4 Kubernetes
Manifiestos en `k8s/`:
- **Deployment** con 2 réplicas, probes y requests/limits.
- **Service** (ClusterIP) y **Ingress**.
- **HPA** (auto-escalado 2→5 réplicas por CPU).

[CAPTURA: `kubectl get pods,svc,hpa -n nginx-app`]

### 2.5 Monitoreo
- **Prometheus** (Deployment + ConfigMap + Service) scrapeando la app.
- **Grafana** con el datasource de Prometheus ya provisionado.

[CAPTURA: targets UP en Prometheus y un dashboard en Grafana]

### 2.6 FinOps
- HPA + requests/limits + imagen liviana.
- Script `finops/cleanup.sh` para apagar recursos no usados.

## 3. Seguridad
- Credenciales con secretos de GitHub (`GITHUB_TOKEN`), nada hardcodeado en el repo.
- Análisis SAST (Trivy) y DAST (OWASP ZAP) dentro del pipeline.
- Imagen mínima para reducir superficie de ataque.

## 4. Cómo replicar
Seguir el `README.md` del repositorio (secciones *Ejecutar localmente*,
*Ejecutar en entorno de pruebas* y *Monitoreo*).

## 5. Conclusión
El proyecto integra toda la cadena DevOps vista en el curso de forma simple y
reproducible: desde el build de la imagen hasta el despliegue en Kubernetes con
monitoreo y control de costos, automatizado por CI/CD.

## 6. Evidencias
- [ ] Captura build/run de Docker
- [ ] Captura de Terraform apply
- [ ] Captura del pipeline en verde
- [ ] Captura de pods/HPA en Kubernetes
- [ ] Captura de Prometheus (targets) y Grafana (dashboard)
- [ ] Link al repositorio
