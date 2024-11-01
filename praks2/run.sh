#!/bin/bash

# Lõpmatu tsükkel, mis töötab kuni kasutaja vajutab 'X' klahvi
while true; do
    # Küsi kasutajalt sisestada kasutajanimi
    echo "Sisesta kasutajanimi (või vajuta 'X', et väljuda): "
    read -r kasutajanimi

    # Kontrolli, kas kasutajanimeks on sisestatud 'X' (suur või väike täht)
    if [[ "$kasutajanimi" == "X" || "$kasutajanimi" == "x" ]]; then
        echo "Kasutajate lisamine lõpetatud."
        break  # Lõpeta tsükkel ja välju programmist
    fi

    # Kontrolli, et kasutajanimi oleks Linuxile sobilik
    # Kasutajanimi peab algama tähega ja võib sisaldada ainult väiketähti, numbreid ja alakriipsu
    if ! [[ "$kasutajanimi" =~ ^[a-z][-a-z0-9_]*$ ]]; then
        echo "Vale kasutajanimi. See peab algama tähega ja sisaldama ainult väiketähti, numbreid ja alakriipsu."
        continue  # Tagasi algusesse, et küsida uut nime
    fi

    # Küsi grupi nime, mis võib olla kas "opilased" või "opetajad"
    echo "Sisesta grupp (opilased/opetajad): "
    read -r grupp

    # Kontrolli, kas grupp on kas "opilased" või "opetajad"
    if [[ "$grupp" != "opilased" && "$grupp" != "opetajad" ]]; then
        echo "Vale grupp. Palun sisesta kas 'opilased' või 'opetajad'."
        continue  # Tagasi algusesse, et küsida uus grupp
    fi

    # Kontrolli, kas grupp eksisteerib süsteemis, kasutades 'getent group' käsku
    if ! getent group "$grupp" > /dev/null; then
        # Kui gruppi pole olemas, siis loome selle
        sudo groupadd "$grupp"
        if [ $? -ne 0 ]; then
            echo "Grupi loomine ebaõnnestus."
            continue  # Tagasi algusesse, et proovida uuesti
        fi
    fi

    # Loome kasutaja süsteemi, kasutades `useradd` käsku
    # -m loob kodukataloogi
    # -s määrab kasutaja koorikuks (shell) /bin/bash
    # -G määrab kasutaja grupi (kas opilased või opetajad)
    sudo useradd -m -s /bin/bash -G "$grupp" "$kasutajanimi"

    # Kontrollime, kas kasutaja loomine õnnestus
    if [ $? -ne 0 ]; then  # $? annab tagasi viimase käsu olekukoodi (0 tähendab õnnestumist)
        echo "Kasutaja loomisel tekkis viga. Kontrolli sisestatud andmeid."
        continue  # Tagasi algusesse, et proovida uuesti
    fi

    # Määrame kasutajale parooli
    echo "Määra parool kasutajale $kasutajanimi: "
    sudo passwd "$kasutajanimi"

    # Kuvame kasutaja kohta info
    echo "Kasutaja edukalt loodud:"
    echo "Kasutajanimi: $kasutajanimi"
    echo "Grupp: $grupp"
    echo "Kodukataloog: /home/$kasutajanimi"
    echo "Koorik (shell): /bin/bash"
    echo "Parool: Määratud (parooli ei kuvata turvalisuse kaalutlustel)"

    echo "Kasutaja $kasutajanimi lisati edukalt süsteemi."
done

