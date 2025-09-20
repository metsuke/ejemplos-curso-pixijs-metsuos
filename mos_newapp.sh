#!/bin/bash

# Copia 002-MOSIntegrate con nuevo nombre y ajusta el destino de copia de la compilacion
# Este es el script que yo uso para los ejemplos, es posible que tengas que ajustarlo para tus necesidades.

# Verifica si se proporcionó un nombre como parámetro
echo "Verificando si se proporcionó un nombre como parámetro..."
if [ -z "$1" ]; then
    echo "Error: No se proporcionó un nombre. Por favor, proporciona un nombre como parámetro."
    exit 1
fi
echo "Nombre proporcionado: $1"

# Convierte el nombre de entrada y elimina espacios
echo "Convirtiendo el nombre "

# Paso 1: Convertir todo a minúsculas
step1=$(echo "$1" | tr '[:upper:]' '[:lower:]')
echo "Convirtiendo el nombre: $step1"

# Paso 2: Cambiar espacios por guiones
step2=$(echo "$step1" | tr ' ' '-')
echo "Convirtiendo el nombre: $step2"

# Paso 3: Capitalizar la primera letra de cada grupo de letras (delimitado por guiones)
step3=$(echo "$step2" | awk -F- '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1' OFS=-)
echo "Nombre con guiones: $step3"

# Paso 4: Sin Guiones
new_name=$(echo "$step3" | tr -d '-')
echo "Nombre convertido: $new_name"

# Busca el número más alto en las carpetas con el patrón *-MOSIntegrate
echo "Buscando la carpeta con el número más alto en el formato [0-9][0-9][0-9]-*..."
highest_num=0
for folder in [0-9][0-9][0-9]-*; do
    if [ -d "$folder" ]; then
        num=${folder%%-*}
        if [[ $num =~ ^[0-9]+$ ]] && [ $num -gt $highest_num ]; then
            highest_num=$num
        fi
    fi
done
echo "Número más alto encontrado: $highest_num"

# Calcula el nuevo número (incrementa en 1)
echo "Calculando el nuevo número incrementando en 1..."
new_num=$(printf "%03d" $((highest_num + 1)))
echo "Nuevo número: $new_num"

# Crea el nombre de la nueva carpeta
echo "Creando el nombre de la nueva carpeta..."
new_folder="${new_num}-${new_name}"
echo "Nombre de la nueva carpeta: $new_folder"

# Verifica si existe la carpeta fuente
echo "Verificando si existe una carpeta fuente para copiar..."
source_folder=$(ls -d [0-9][0-9][0-9]-MOSIntegrate 2>/dev/null | tail -1)
if [ -z "$source_folder" ]; then
    echo "Error: No se encontró ninguna carpeta con el formato [0-9][0-9][0-9]-MOSIntegrate para copiar."
    exit 1
fi
echo "Carpeta fuente encontrada: $source_folder"

# Crea una copia de la carpeta
echo "Copiando la carpeta $source_folder a $new_folder..."
rsync -a --exclude='node_modules' --exclude='dist' "$source_folder/" "$new_folder/"

# Verifica si la copia fue exitosa
if [ $? -ne 0 ]; then
    echo "Error: No se pudo crear la copia de la carpeta $source_folder."
    exit 1
fi
echo "Copia creada exitosamente: $new_folder"

# Actualiza datos del fichero vite.config.js
nombre_proyecto=$(echo "$new_name" | tr '[:upper:]' '[:lower:]')
mos_vite_file="$new_folder/vite.config.ts"
echo "Ajustando $mos_vite_file"
if [ -f "$mos_vite_file" ]; then
    awk -v old="MOSIntegrate" -v new="$nombre_proyecto" '{gsub(old, new); print}' "$mos_vite_file" > "${mos_vite_file}.tmp" && mv "${mos_vite_file}.tmp" "$mos_vite_file"
    awk -v old="mos-integrate" -v new="$nombre_proyecto" '{gsub(old, new); print}' "$mos_vite_file" > "${mos_vite_file}.tmp" && mv "${mos_vite_file}.tmp" "$mos_vite_file"
    if [ $? -eq 0 ]; then
        echo "Éxito VITE: se actualizó el archivo vite.config.js correctamente."
    else
        echo "Error VITE: No se pudo actualizar el archivo vite.config.js"
        exit 1
    fi
fi

# Actualiza el nombre del proyecto en package.json
nombre_proyecto=$(echo "$new_folder" | tr '[:upper:]' '[:lower:]')
mos_package_file="$new_folder/package.json"
if [ -f "$mos_package_file" ]; then
    awk -v old="002-mosintegrate" -v new="$nombre_proyecto" '{gsub(old, new); print}' "$mos_package_file" > "${mos_package_file}.tmp" && mv "${mos_package_file}.tmp" "$mos_package_file"
    if [ $? -eq 0 ]; then
        echo "Éxito JSON: se actualizó el archivo package.json correctamente."
    else
        echo "Error JSON: No se pudo actualizar el archivo package.json"
        exit 1
    fi
fi

# Actualiza el archivo mos_compile.sh en la nueva carpeta
echo "Buscando el archivo mos_compile.sh en la nueva carpeta..."
mos_compile_file="$new_folder/mos_compile.sh"
if [ -f "$mos_compile_file" ]; then
    echo "Actual Fundamentando el archivo mos_compile.sh, reemplazando $source_folder por $new_folder..."
    # Depuración: Mostrar las variables
    echo "DEBUG: source_folder='$source_folder'"
    echo "DEBUG: new_folder='$new_folder'"
    # Usar awk para reemplazar source_folder por new_folder
    awk -v old="002-MosIntegration" -v new="$new_folder" '{gsub(old, new); print}' "$mos_compile_file" > "${mos_compile_file}.tmp" && mv "${mos_compile_file}.tmp" "$mos_compile_file"
    if [ $? -eq 0 ]; then
        echo "Éxito: Se creó la carpeta $new_folder y se actualizó el archivo mos_compile.sh correctamente."
    else
        echo "Error: No se pudo actualizar el archivo mos_compile.sh."
        exit 1
    fi
else
    echo "Error: No se encontró el archivo mos_compile.sh en $new_folder."
    exit 1
fi
# Tras modificarlo marcamos como ejecutable
chmod +x "$mos_compile_file"

# Cambiar al directorio de la nueva carpeta e instalar dependencias
echo "Cambiando al directorio $new_folder e instalando dependencias..."
cd "$new_folder" || { echo "Error: No se pudo cambiar al directorio $new_folder."; exit 1; }
npm install --verbose
if [ $? -eq 0 ]; then
    echo "Éxito: Dependencias instaladas correctamente en $new_folder."
else
    echo "Error: No se pudieron instalar las dependencias en $new_folder."
    exit 1
fi