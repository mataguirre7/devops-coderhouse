# Un dockerfile es la RECETA para construir una imagen.
# Cada instrucción de abajo crea una capa nueva sobre la anterior.
# 
# FROM: la imagen base sobre la que construimos.
# nginx es un servidor web; "alpine" es una variante mínima (aprox 10MB).

FROM nginx:alpine

LABEL autor="MATIAS"
LABEL description="Dockerfile para levantar un contenedor con Nginx y un sitio web estático"

# COPY: copia archivos desde el host al contenedor.
# usr/share/nginx/html es la carpeta que nginx publica por defecto

# COPY [origen pc] [destino contendor]
COPY index.html /usr/share/nginx/html
COPY styles.css /usr/share/nginx/html

# EXPOSE: documenta que puerto usa la aplicación adentro del contenedor.
# Es informativo: la publicación real se hace con -p en docker run.
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]