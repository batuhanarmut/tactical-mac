#!/bin/bash

# Tactical RMM Agent Kurulum Scripti - macOS
# Tactical RMM Agent Installation Script - macOS

clear

echo "=================================================="
echo "  Tactical RMM Agent Kurulum / Installation"
echo "=================================================="
echo ""
echo "Lütfen kurmak istediğiniz agent'ı seçin:"
echo "Please select the agent you want to install:"
echo ""
echo "1) Armut"
echo "2) Pronto Pro"
echo ""
read -p "Seçiminiz / Your choice (1 veya 2): " choice

case $choice in
    1)
        echo ""
        echo "Armut agent kurulumu başlatılıyor..."
        echo "Starting Armut agent installation..."
        echo ""
        
        AGENT_URL='https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io'
        CLIENT_ID=1
        SITE_ID=2
        AUTH_TOKEN="b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
        COMPANY="Armut"
        ;;
    2)
        echo ""
        echo "Pronto Pro agent kurulumu başlatılıyor..."
        echo "Starting Pronto Pro agent installation..."
        echo ""
        
        AGENT_URL='https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io'
        CLIENT_ID=1
        SITE_ID=1
        AUTH_TOKEN="7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
        COMPANY="Pronto Pro"
        ;;
    *)
        echo ""
        echo "Geçersiz seçim! Lütfen 1 veya 2 seçin."
        echo "Invalid choice! Please select 1 or 2."
        exit 1
        ;;
esac

# macOS kontrolü / macOS check
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo ""
    echo "HATA: Bu script sadece macOS için tasarlanmıştır!"
    echo "ERROR: This script is designed for macOS only!"
    exit 1
fi

# Agent dosyasını indir / Download agent file
echo "Agent dosyası indiriliyor..."
echo "Downloading agent file..."
curl -L -o tacticalagent-v2.9.1-darwin-arm64 "$AGENT_URL"

if [ $? -ne 0 ]; then
    echo ""
    echo "HATA: Agent dosyası indirilemedi!"
    echo "ERROR: Failed to download agent file!"
    exit 1
fi

# Çalıştırma izni ver / Grant execution permission
echo ""
echo "Çalıştırma izni veriliyor..."
echo "Granting execution permission..."
chmod +x tacticalagent-v2.9.1-darwin-arm64

# Agent'ı kur / Install agent
echo ""
echo "$COMPANY agent kuruluyor..."
echo "Installing $COMPANY agent..."
echo ""
echo "Not: Sudo şifresi istenecektir."
echo "Note: You will be prompted for sudo password."
echo ""

sudo ./tacticalagent-v2.9.1-darwin-arm64 -m install \
    --api https://api.trmm.homeruntech.io \
    --client-id $CLIENT_ID \
    --site-id $SITE_ID \
    --agent-type workstation \
    --auth $AUTH_TOKEN

if [ $? -eq 0 ]; then
    echo ""
    echo "=================================================="
    echo "✓ $COMPANY agent başarıyla kuruldu!"
    echo "✓ $COMPANY agent installed successfully!"
    echo "=================================================="
    
    # Kurulum dosyasını temizle / Clean up installation file
    rm -f tacticalagent-v2.9.1-darwin-arm64
    echo ""
    echo "Kurulum dosyası temizlendi."
    echo "Installation file cleaned up."
else
    echo ""
    echo "=================================================="
    echo "✗ Agent kurulumu başarısız oldu!"
    echo "✗ Agent installation failed!"
    echo "=================================================="
    exit 1
fi
