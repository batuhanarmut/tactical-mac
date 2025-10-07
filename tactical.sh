#!/bin/bash

# Tactical RMM Agent Kurulum Scripti - macOS
# Tactical RMM Agent Installation Script - macOS

clear

echo "=================================================="
echo "  Tactical RMM Agent Kurulum / Installation"
echo "=================================================="
echo ""

# macOS kontrolü / macOS check
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "HATA: Bu script sadece macOS için tasarlanmıştır!"
    echo "ERROR: This script is designed for macOS only!"
    echo ""
    exit 1
fi

echo "Lütfen kurmak istediğiniz agent'ı seçin:"
echo "Please select the agent you want to install:"
echo ""
echo "1) Armut"
echo "2) Pronto Pro"
echo ""
echo -n "Seçiminiz / Your choice (1 veya 2): "
read choice

echo ""

case $choice in
    1)
        echo "✓ Armut seçildi / Armut selected"
        echo ""
        echo "Armut agent kurulumu başlatılıyor..."
        echo "Starting Armut agent installation..."
        echo ""
        
        CLIENT_ID=1
        SITE_ID=2
        AUTH_TOKEN="b34762d00cfd286deddf75e085d6ea0364b31eac78ef40471a544b510a0b4fc1"
        COMPANY="Armut"
        ;;
    2)
        echo "✓ Pronto Pro seçildi / Pronto Pro selected"
        echo ""
        echo "Pronto Pro agent kurulumu başlatılıyor..."
        echo "Starting Pronto Pro agent installation..."
        echo ""
        
        CLIENT_ID=1
        SITE_ID=1
        AUTH_TOKEN="7fcee3d368ec1e1832b92a414690e524415c0784996c2d3479f7fb8dbf925e6e"
        COMPANY="Pronto Pro"
        ;;
    *)
        echo "✗ Geçersiz seçim! Lütfen 1 veya 2 seçin."
        echo "✗ Invalid choice! Please select 1 or 2."
        echo ""
        exit 1
        ;;
esac

# Agent URL'si
AGENT_URL='https://agents.tacticalrmm.com/api/v2/agents/?version=2.9.1&arch=arm64&token=e0cb907b-1c72-4f4b-b4ff-83fc4d2b3713&plat=darwin&api=api.trmm.homeruntech.io'
AGENT_FILE="tacticalagent-v2.9.1-darwin-arm64"

# Agent dosyasını indir / Download agent file
echo "Agent dosyası indiriliyor..."
echo "Downloading agent file..."
echo ""

curl -L -o "$AGENT_FILE" "$AGENT_URL"

if [ $? -ne 0 ]; then
    echo ""
    echo "✗ HATA: Agent dosyası indirilemedi!"
    echo "✗ ERROR: Failed to download agent file!"
    echo ""
    exit 1
fi

echo ""
echo "✓ İndirme tamamlandı / Download completed"
echo ""

# Dosya boyutunu kontrol et
if [ ! -f "$AGENT_FILE" ]; then
    echo "✗ HATA: Agent dosyası bulunamadı!"
    echo "✗ ERROR: Agent file not found!"
    echo ""
    exit 1
fi

FILE_SIZE=$(wc -c < "$AGENT_FILE")
if [ $FILE_SIZE -lt 1000 ]; then
    echo "✗ HATA: İndirilen dosya çok küçük, indirme başarısız olmuş olabilir!"
    echo "✗ ERROR: Downloaded file is too small, download may have failed!"
    echo ""
    rm -f "$AGENT_FILE"
    exit 1
fi

# Çalıştırma izni ver / Grant execution permission
echo "Çalıştırma izni veriliyor..."
echo "Granting execution permission..."
chmod +x "$AGENT_FILE"

if [ $? -ne 0 ]; then
    echo ""
    echo "✗ HATA: Çalıştırma izni verilemedi!"
    echo "✗ ERROR: Failed to grant execution permission!"
    echo ""
    exit 1
fi

echo ""
echo "✓ İzin verildi / Permission granted"
echo ""

# Kurulum bilgilerini göster
echo "=================================================="
echo "Kurulum Bilgileri / Installation Details:"
echo "=================================================="
echo "Şirket / Company: $COMPANY"
echo "Client ID: $CLIENT_ID"
echo "Site ID: $SITE_ID"
echo "API: https://api.trmm.homeruntech.io"
echo "Agent Type: workstation"
echo "=================================================="
echo ""

# Onay iste
echo -n "Kuruluma devam etmek istiyor musunuz? (e/h) / Continue? (y/n): "
read confirm

if [[ ! "$confirm" =~ ^[eEyY]$ ]]; then
    echo ""
    echo "Kurulum iptal edildi / Installation cancelled"
    rm -f "$AGENT_FILE"
    exit 0
fi

# Agent'ı kur / Install agent
echo ""
echo "=================================================="
echo "$COMPANY agent kuruluyor..."
echo "Installing $COMPANY agent..."
echo "=================================================="
echo ""
echo "Not: Sudo şifresi istenecektir."
echo "Note: You will be prompted for sudo password."
echo ""

sudo ./"$AGENT_FILE" -m install \
    --api https://api.trmm.homeruntech.io \
    --client-id $CLIENT_ID \
    --site-id $SITE_ID \
    --agent-type workstation \
    --auth $AUTH_TOKEN

INSTALL_STATUS=$?

echo ""

if [ $INSTALL_STATUS -eq 0 ]; then
    echo "=================================================="
    echo "✓ $COMPANY agent başarıyla kuruldu!"
    echo "✓ $COMPANY agent installed successfully!"
    echo "=================================================="
    echo ""
    
    # Kurulum dosyasını temizle / Clean up installation file
    rm -f "$AGENT_FILE"
    echo "Kurulum dosyası temizlendi."
    echo "Installation file cleaned up."
    echo ""
    
    # Agent durumunu kontrol et
    echo "Agent durumu kontrol ediliyor..."
    echo "Checking agent status..."
    echo ""
    
    if sudo launchctl list | grep -q "tacticalagent"; then
        echo "✓ Agent servisi çalışıyor / Agent service is running"
    else
        echo "⚠ Uyarı: Agent servisi bulunamadı / Warning: Agent service not found"
    fi
else
    echo "=================================================="
    echo "✗ Agent kurulumu başarısız oldu!"
    echo "✗ Agent installation failed!"
    echo "=================================================="
    echo ""
    echo "Hata Kodu / Error Code: $INSTALL_STATUS"
    echo ""
    echo "Olası sebepler / Possible reasons:"
    echo "- Sudo şifresi yanlış girilmiş olabilir"
    echo "- Ağ bağlantısı sorunu olabilir"
    echo "- API sunucusuna erişim sorunu olabilir"
    echo ""
    
    # Hata durumunda dosyayı silme, inceleme için bırak
    echo "Hata ayıklama için agent dosyası saklandı: $AGENT_FILE"
    echo "Agent file kept for debugging: $AGENT_FILE"
    echo ""
    exit 1
fi

echo ""
echo "Kurulum tamamlandı! / Installation completed!"
echo ""
