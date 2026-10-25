# ---- Stage 1: build ----
# Para un sitio estatico no hay mucho que "compilar", pero uso una etapa
# de build para preparar los archivos (y dejar lugar a minificar mas adelante).
FROM alpine:3.20 AS build
WORKDIR /site
COPY index.html .
COPY css ./css

# ---- Stage 2: imagen final ----
FROM nginx:alpine
# Copio solo lo necesario desde la etapa de build (imagen final mas liviana)
COPY --from=build /site /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
