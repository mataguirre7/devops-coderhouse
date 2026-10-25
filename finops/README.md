# FinOps - Optimización de costos

Medidas simples aplicadas en este proyecto para no gastar de más:

1. **Auto-escalado (HPA):** la app escala entre 2 y 5 réplicas según el uso de CPU
   (ver `k8s/hpa.yaml`). Así solo se usan recursos cuando hacen falta.
2. **Requests y limits:** todos los contenedores tienen `resources.requests` y
   `resources.limits` definidos. Esto evita que un pod consuma de más y permite
   al cluster hacer un mejor packing de los nodos.
3. **Imagen liviana:** Dockerfile multi-stage sobre `nginx:alpine` → imagen chica,
   menos almacenamiento en el registry y descargas más rápidas.
4. **Apagado de recursos no usados:** el script `cleanup.sh` escala a 0 la app y el
   monitoreo cuando no se usan. En la nube esto se puede automatizar con un cron.

## Uso

```bash
bash finops/cleanup.sh
```
