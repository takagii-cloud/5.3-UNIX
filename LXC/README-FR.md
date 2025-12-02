# createlxc.sh

## Description

Ce script Bash permet de créer et configurer automatiquement un conteneur **LXC Debian**.  
Il installe les outils essentiels, configure la locale française et crée un utilisateur avec droits sudo.

---

## Prérequis

- Avoir **LXC installé**
- Exécuter le script en **root**
- Template LXC `download` disponible

---

## Ce que fait le script

1. Vérifie que vous êtes root  
2. Crée un conteneur Debian Trixie  
3. Démarre le conteneur  
4. Installe :
   - `locales`
   - `openssh-server`
   - `sudo`
5. Configure la locale `fr_FR.UTF-8`  
6. Crée un utilisateur et définit son mot de passe  
7. Ajoute l’utilisateur au groupe `sudo`  
8. Affiche les informations finales de connexion

---

## Utilisation

Exécutez simplement :

```bash
sudo ./script.sh
