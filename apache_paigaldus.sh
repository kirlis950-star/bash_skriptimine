#!/bin/bash

#see script

# Kontrollime, kas apache2 teenus on paigaldatud
if dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -q "ok installed"; then
    echo "Apache2 teenus on juba paigaldatud."
    # Näitame teenuse staatust
    systemctl status apache2
else
    echo "Apache2 teenust ei ole paigaldatud. Paigaldame nüüd..."
    # Paigaldame apache2 teenuse
    sudo apt update
    sudo apt install -y apache2
    
    # Kontrollime uuesti, kas paigaldus õnnestus
    if dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -q "ok installed"; then
        echo "Apache2 teenus on edukalt paigaldatud."
        # Käivitame teenuse ja näitame staatust
        sudo systemctl start apache2
        sudo systemctl enable apache2
        systemctl status apache2
    else
        echo "Apache2 paigaldamine ebaõnnestus."
    fi
fi

