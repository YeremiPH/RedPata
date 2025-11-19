#!/usr/bin/env bash
set -euo pipefail

# Script seguro para limpiar el historial remoto de artefactos grandes
# USO: ejecutar desde cualquier lugar: bash scripts/clean_repo.sh
# ADVERTENCIA: Este script reescribe el historial remoto (git filter-repo).
# Haz backup antes (este script crea un tarball de copia de seguridad).

REPO_DIR="/home/yeremi/Documents/ProyectosGitHub/RedPata"
BACKUP_DIR="/home/yeremi/Documents/ProyectosGitHub"
REMOTE_URL="https://github.com/YeremiPH/RedPata.git"

cd "$BACKUP_DIR"

# 1) Backup (tar) de la copia actual de trabajo
BACKUP_FILE="RedPata-backup-$(date +%Y%m%d%H%M%S).tar.gz"
if [ -d "$REPO_DIR" ]; then
  echo "Creando backup de $REPO_DIR -> $BACKUP_FILE"
  tar -czf "$BACKUP_FILE" -C "$(dirname "$REPO_DIR")" "$(basename "$REPO_DIR")" || true
  echo "Backup creado: $BACKUP_FILE"
else
  echo "Directorio $REPO_DIR no existe. Abortando."
  exit 1
fi

# 2) Clonar mirror del remoto
MIRROR_DIR="RedPata-mirror.git"
rm -rf "$MIRROR_DIR" || true
echo "Clonando mirror desde $REMOTE_URL"
git clone --mirror "$REMOTE_URL" "$MIRROR_DIR"
cd "$MIRROR_DIR"

# 3) Instalar git-filter-repo si no existe
if ! command -v git-filter-repo >/dev/null 2>&1; then
  echo "git-filter-repo no encontrado, intentando instalar via pip (usuario)."
  python3 -m pip install --user git-filter-repo || true
  export PATH="$HOME/.local/bin:$PATH"
fi

# 4) Ejecutar git-filter-repo para eliminar carpetas y artefactos grandes
# Rutas a eliminar del historial (puedes modificar según prefieras)
PATHS=(
  "build"
  ".dart_tool"
  ".flutter-plugins-dependencies"
  ".flutter-plugins"
)
GLOBS=(
  "build/**"
  "**/kernel_blob.bin"
  "**/*.apk"
)

# Construir argumentos
ARGS=(--invert-paths)
for p in "${PATHS[@]}"; do
  ARGS+=(--path "$p")
done
for g in "${GLOBS[@]}"; do
  ARGS+=(--path-glob "$g")
done

# Ejecutar (usar el binario si existe, si no usar el módulo de python)
if command -v git-filter-repo >/dev/null 2>&1; then
  echo "Ejecutando: git-filter-repo ${ARGS[*]}"
  git-filter-repo "${ARGS[@]}"
else
  echo "Ejecutando: python3 -m git_filter_repo ${ARGS[*]}"
  python3 -m git_filter_repo "${ARGS[@]}"
fi

# 5) Fuerza push del historial reescrito
echo "Forzando push del historial limpio al remoto..."
git push --force --all origin || true
git push --force --tags origin || true

# 6) Mensaje final
echo "Limpieza completada."

echo "IMPORTANTE: Ahora debes reclonar el repositorio en tu copia de trabajo local:" 
 echo "  mv RedPata RedPata-old || true"
 echo "  git clone $REMOTE_URL"

exit 0
