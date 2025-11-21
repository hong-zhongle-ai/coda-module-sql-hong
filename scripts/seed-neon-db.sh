#!/bin/bash

# Script pour seed la base de données Neon avec les fichiers init-schema.sql et seed-data.sql
# Usage: ./scripts/seed-neon-db.sh

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# URL de connexion à la base de données Neon
DATABASE_URL="postgresql://neondb_owner:npg_NMs0AV3ZLDpR@ep-wispy-mouse-agpqqxkp-pooler.c-2.eu-central-1.aws.neon.tech/neondb?sslmode=require"

# Chemins des fichiers SQL
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INIT_SCHEMA_FILE="${SCRIPT_DIR}/init-schema.sql"
SEED_DATA_FILE="${SCRIPT_DIR}/seed-data.sql"

echo -e "${YELLOW}🚀 Démarrage du seed de la base de données Neon...${NC}\n"

# Vérifier que psql est installé
if ! command -v psql &> /dev/null; then
    echo -e "${RED}❌ Erreur: psql n'est pas installé.${NC}"
    echo "Installez PostgreSQL client pour utiliser ce script."
    exit 1
fi

# Vérifier que les fichiers SQL existent
if [ ! -f "$INIT_SCHEMA_FILE" ]; then
    echo -e "${RED}❌ Erreur: Fichier introuvable: $INIT_SCHEMA_FILE${NC}"
    exit 1
fi

if [ ! -f "$SEED_DATA_FILE" ]; then
    echo -e "${RED}❌ Erreur: Fichier introuvable: $SEED_DATA_FILE${NC}"
    exit 1
fi

# Test de connexion
echo -e "${YELLOW}📡 Test de connexion à la base de données...${NC}"
if ! psql "$DATABASE_URL" -c "SELECT version();" > /dev/null 2>&1; then
    echo -e "${RED}❌ Erreur: Impossible de se connecter à la base de données.${NC}"
    echo "Vérifiez votre connexion internet et les identifiants de la base de données."
    exit 1
fi
echo -e "${GREEN}✅ Connexion réussie${NC}\n"

# Exécuter le script d'initialisation du schéma
echo -e "${YELLOW}📋 Création du schéma et des tables...${NC}"
if psql "$DATABASE_URL" -f "$INIT_SCHEMA_FILE"; then
    echo -e "${GREEN}✅ Schéma créé avec succès${NC}\n"
else
    echo -e "${RED}❌ Erreur lors de la création du schéma${NC}"
    exit 1
fi

# Exécuter le script de seed des données
echo -e "${YELLOW}🌱 Insertion des données...${NC}"
echo "Cette opération peut prendre quelques minutes..."
if psql "$DATABASE_URL" -f "$SEED_DATA_FILE"; then
    echo -e "${GREEN}✅ Données insérées avec succès${NC}\n"
else
    echo -e "${RED}❌ Erreur lors de l'insertion des données${NC}"
    exit 1
fi

# Afficher un résumé
echo -e "${YELLOW}📊 Résumé des données insérées:${NC}"
psql "$DATABASE_URL" -c "
SET search_path TO student;
SELECT 
    'Établissements' as type, COUNT(*) as nombre FROM etablissement
UNION ALL
SELECT 'Étudiants', COUNT(*) FROM etudiant
UNION ALL
SELECT 'Cours', COUNT(*) FROM cours
UNION ALL
SELECT 'Inscriptions', COUNT(*) FROM inscription
UNION ALL
SELECT 'Notes', COUNT(*) FROM note;
"

echo -e "\n${GREEN}🎉 Seed de la base de données terminé avec succès!${NC}"

