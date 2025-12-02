#!/usr/bin/env bash

set -eu

# Paramètres
CONTAINER_NAME="c3"
USER_NAME="ataha"
USER_PASSWORD="ataha"

TEMPLATE="download"
DIST="debian"
RELEASE="trixie"
ARCH="amd64"

msg() {
    printf '[*] %s\n' "$*"
}

error() {
    printf '[ERREUR] %s\n' "$1" >&2
    exit 1
}

# Vérifier qu'on est root
if [ "$(id -u)" -ne 0 ]; then
    error "Ce script doit être exécuté en root."
fi

msg "Étape 1/5 : création du conteneur ${CONTAINER_NAME} (Debian ${RELEASE})..."

lxc-create -n "${CONTAINER_NAME}" -t "${TEMPLATE}" -- \
    --dist "${DIST}" --release "${RELEASE}" --arch "${ARCH}"

msg "Étape 2/5 : démarrage du conteneur..."
lxc-start -n "${CONTAINER_NAME}" -d

msg "Étape 3/5 : installation de locales, ssh et sudo..."
lxc-attach -n "${CONTAINER_NAME}" -- bash -c '
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y locales openssh-server sudo
'

msg "Étape 4/5 : configuration de la locale fr_FR.UTF-8..."
lxc-attach -n "${CONTAINER_NAME}" -- bash -c '
    sed -i "s/^# *\(fr_FR.UTF-8 UTF-8\)/\1/" /etc/locale.gen
    locale-gen fr_FR.UTF-8
    update-locale LANG=fr_FR.UTF-8
'

msg "Étape 5/5 : création de l'utilisateur et configuration sudo..."

# Création de l'utilisateur
lxc-attach -n "${CONTAINER_NAME}" -- bash -c "
    id ${USER_NAME} >/dev/null 2>&1 || useradd -m -s /bin/bash ${USER_NAME}
"

# Mot de passe
printf '%s:%s\n' "${USER_NAME}" "${USER_PASSWORD}" | \
    lxc-attach -n "${CONTAINER_NAME}" -- chpasswd

# Ajout au groupe sudo
lxc-attach -n "${CONTAINER_NAME}" -- usermod -aG sudo "${USER_NAME}"

msg "----------------------------------------"
msg "Configuration terminée."
msg "Conteneur : ${CONTAINER_NAME}"
msg "Utilisateur : ${USER_NAME}"
msg "Mot de passe : ${USER_PASSWORD}"
msg "Connexion : sudo lxc-attach -n ${CONTAINER_NAME} -- su - ${USER_NAME}"
