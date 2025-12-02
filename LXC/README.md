# createlxc.sh

## Description

This Bash script automatically creates and configures a **Debian LXC container**.  
It installs essential tools, sets the French locale, and creates a user with sudo privileges.

---

## Requirements

- **LXC installed**
- Script must be executed as **root**
- LXC `download` template available

---

## What the script does

1. Checks if the script is run as root  
2. Creates a Debian Trixie container  
3. Starts the container  
4. Installs:
   - `locales`
   - `openssh-server`
   - `sudo`
5. Configures the `fr_FR.UTF-8` locale  
6. Creates a user and sets a password  
7. Adds the user to the `sudo` group  
8. Displays final connection instructions

---

## Usage

Run the script with:

```bash
sudo ./script.sh
