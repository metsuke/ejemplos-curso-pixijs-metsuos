#!/bin/bash

# Definir la carpeta de destino
DESTINATION_FOLDER="/Users/Metsuke/__OBSIDIAN/23-PublicBrain-WebGenerated/01_AA - Web Template Manual/10 APPS/PixiJS/003-MosFormasGeometricas"

# Prettier
echo "Ejecutando prettier..."
npx prettier --write src/main.ts

# Ejecutar el comando de compilación
echo "Ejecutando npm run build..."
npm run build

# Verificar si la compilación fue exitosa
if [ $? -eq 0 ]; then
  echo "Compilación exitosa."

  # Limpiar la carpeta de destino (crearla si no existe)
  echo "Limpiando la carpeta de destino: $DESTINATION_FOLDER"
  rm -rf "$DESTINATION_FOLDER"/* || { echo "No se pudo limpiar la carpeta de destino"; exit 1; }
  mkdir -p "$DESTINATION_FOLDER"

  # Copiar el contenido de la carpeta dist al destino
  echo "Copiando dist a $DESTINATION_FOLDER"
  cp -r dist/* "$DESTINATION_FOLDER" || { echo "No se pudo copiar dist al destino"; exit 1; }

  echo "Compilación y despliegue completados con éxito."
else
  echo "La compilación falló."
  exit 1
fi
