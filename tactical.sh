# Yeni bir dosya oluştur (temiz Unix formatında)
cat > tactical_clean.sh << 'SCRIPT_END'
#!/bin/bash

clear
echo "=== Tactical RMM Agent Kurulum ==="
echo "=== Tactical RMM Agent Installation ==="
echo ""

echo "Dil seciniz / Select Language:"
echo "1) Turkce"
echo "2) English"
echo ""

read -p "Seciminiz / Your choice (1-2): " LANG_CHOICE

case $LANG_CHOICE in
    1)
        echo "Turkce secildi"
        echo ""
        echo "Sirket seciniz:"
        echo "1) Armut"
        echo "2) Pronto Pro"
        echo ""
        read -p "Sirket (1-2): " COMPANY_CHOICE
        ;;
    2)
        echo "English selected"
        echo ""
        echo "Select company:"
        echo "1) Armut" 
        echo "2) Pronto Pro"
        echo ""
        read -p "Company (1-2): " COMPANY_CHOICE
        ;;
    *)
        echo "Invalid choice / Gecersiz secim"
        exit 1
        ;;
esac

case $COMPANY_CHOICE in
    1)
        if [ "$LANG_CHOICE" = "1" ]; then
            echo "Armut secildi"
        else
            echo "Armut selected"
        fi
        CLIENT_ID=1
        SITE_ID=2
        AUTH_TOKEN="b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
        COMPANY_NAME="Armut"
        ;;
    2)
        if [ "$LANG_CHOICE" = "1" ]; then
            echo "Pronto Pro secildi"
        else
            echo "Pronto Pro selected"
        fi
        CLIENT_ID=1
        SITE_ID=1
        AUTH_TOKEN="7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
        COMPANY_NAME="Pronto Pro"
        ;;
    *)
        echo "Invalid choice / Gecersiz secim"
        exit 1
        ;;
esac

if [[ "$OSTYPE" != "darwin"* ]]; then
    if [ "$LANG_CHOICE" = "1" ]; then
        echo "Bu script sadece macOS icin!"
    else
        echo "This script is for macOS only!"
    fi
    exit 1
fi

ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    AGENT_ARCH="arm64"
    if [ "$LANG_CHOICE" = "1" ]; then
        echo "Apple Silicon tespit edildi"
    else
        echo "Apple Silicon detected"
    fi
else
    AGENT_ARCH="amd64"
    if [ "$LANG_CHOICE" = "1" ]; then
        echo "Intel Mac tespit edildi"
    else
        echo "Intel Mac detected"
    fi
fi

echo ""
if [ "$LANG_CHOICE" = "1" ]; then
    echo "$COMPANY_NAME icin agent indiriliyor..."
else
    echo "Downloading agent for $COMPANY_NAME..."
fi

AGENT_FILE="tactical-agent-$AGENT_ARCH"
DOWNLOAD_URL="https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=$AGENT_ARCH&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io"

if curl -L -s -o "$AGENT_FILE" "$DOWNLOAD_URL"; then
    if [ "$LANG_CHOICE" = "1" ]; then
        echo "Indirme tamamlandi"
    else
        echo "Download completed"
    fi
else
    if [ "$LANG_CHOICE" = "1" ]; then
        echo "Indirme basarisiz!"
    else
        echo "Download failed!"
    fi
    exit 1
fi

chmod +x "$AGENT_FILE"

echo ""
if [ "$LANG_CHOICE" = "1" ]; then
    echo "Agent kuruluyor..."
    echo "Sifre gerekebilir..."
else
    echo "Installing agent..."
    echo "Password may be required..."
fi

if sudo ./"$AGENT_FILE" -m install --api https://api.trmm.homeruntech.io --client-id $CLIENT_ID --site-id $SITE_ID --agent-type workstation --auth $AUTH_TOKEN; then
    echo ""
    if [ "$LANG_CHOICE" = "1" ]; then
        echo "BASARILI! $COMPANY_NAME agent kuruldu."
        echo "Client ID: $CLIENT_ID"
        echo "Site ID: $SITE_ID"
        echo "Mimari: $ARCH"
    else
        echo "SUCCESS! $COMPANY_NAME agent installed."
        echo "Client ID: $CLIENT_ID"
        echo "Site ID: $SITE_ID"
        echo "Architecture: $ARCH"
    fi
else
    echo ""
    if [ "$LANG_CHOICE" = "1" ]; then
        echo "HATA! Kurulum basarisiz."
    else
        echo "ERROR! Installation failed."
    fi
    exit 1
fi

rm -f "$AGENT_FILE"

echo ""
if [ "$LANG_CHOICE" = "1" ]; then
    echo "Kurulum tamamlandi!"
else
    echo "Installation completed!"
fi
SCRIPT_END

# Dosyayı test et
chmod +x tactical_clean.sh
./tactical_clean.sh

# Dosya çalışıyorsa GitHub'a yükle
