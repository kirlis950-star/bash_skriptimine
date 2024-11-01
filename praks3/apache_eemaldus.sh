#!/bin/bash

# Kontrollime, kas apache2 teenus on paigaldatud
if dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -q "ok installed"; then
    echo "Apache2 teenus on paigaldatud. Eemaldame selle koos kõigi seotud failidega..."

    # Peatame teenuse enne eemaldamist
    sudo systemctl stop apache2

    # Eemaldame apache2 ja kõik sellega seotud failid
    sudo apt remove --purge -y apache2 apache2-utils apache2-bin apache2.2-common

    # Puhastame süsteemi ülejäänud mittevajalike failide eemaldamiseks
    sudo apt autoremove -y
    sudo apt autoclean

    echo "Apache2 teenus ja seotud failid on edukalt eemaldatud."
else
    echo "Apache2 teenust ei ole paigaldatud."
fi

