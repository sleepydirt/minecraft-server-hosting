#!/bin/bash

# Function to check if a command was successful
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Function to check if Java is installed and working
check_java() {
    if ! command -v java &> /dev/null; then
        return 1
    fi
    java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    if [[ -z "$java_version" ]]; then
        return 1
    fi
    return 0
}

# Function to detect package manager
detect_package_manager() {
    if command -v apt-get &>/dev/null; then
        echo "apt-get"
        return
    elif command -v yum &>/dev/null; then
        echo "yum"
        return
    elif command -v dnf &>/dev/null; then
        echo "dnf"
        return
    elif command -v pacman &>/dev/null; then
        echo "pacman"
        return
    elif command -v zypper &>/dev/null; then
        echo "zypper"
        return
    else
        echo "UNKNOWN"
        return
    fi
}

# Detect the package manager
PKG_MANAGER=$(detect_package_manager)

# Function to install Java based on distribution
install_java() {
    case $PKG_MANAGER in
        "apt-get")
            apt-get update
            apt-get install -y openjdk-17-jdk
            ;;
        "yum")
            yum update -y
            amazon-linux-extras install java-openjdk11 -y
            ;;
        "dnf")
            dnf update -y
            dnf install -y java-17-openjdk
            ;;
        "pacman")
            pacman -Syu --noconfirm
            pacman -S --noconfirm jdk17-openjdk
            ;;
        "zypper")
            zypper refresh
            zypper install -y java-17-openjdk
            ;;
        *)
            echo "Unsupported package manager. Please install Java manually."
            exit 1
            ;;
    esac
}

echo "=== Minecraft Server Setup Script ==="
echo "Starting setup process..."
echo "Updating system packages..."
case $PKG_MANAGER in
    "apt-get")
        apt-get update && apt-get upgrade -y
        ;;
    "yum")
        yum update -y
        ;;
    "dnf")
        dnf update -y
        ;;
    "pacman")
        pacman -Syu --noconfirm
        ;;
    "zypper")
        zypper refresh && zypper update -y
        ;;
    *)
        echo "Unsupported package manager. Please update your system manually."
        exit 1
        ;;
esac
check_error "Failed to update system packages"

echo "Installing Java..."
install_java
check_error "Failed to install Java"
# Step 3: Verify Java installation
echo "Verifying Java installation..."
if ! check_java; then
    echo "Java installation failed. Please install Java manually."
    exit 1
fi

# Create directory for Minecraft server
SERVER_DIR="./minecraft"
mkdir -p $SERVER_DIR
sudo chmod 755 $SERVER_DIR
cd $SERVER_DIR
check_error "Failed to create server directory"

# Step 4: Download server.jar
echo "Downloading Minecraft server..."
wget https://piston-data.mojang.com/v1/objects/450698d1863ab5180c25d7c804ef0fe6369dd1ba/server.jar
check_error "Failed to download server.jar"

# Step 5: Initial server run
echo "Performing initial server setup..."
java -Xmx1024M -Xms1024M -jar server.jar nogui || true

# Step 6: Accept EULA
echo "Accepting EULA..."
echo "eula=true" > eula.txt
check_error "Failed to accept EULA"

# Step 7: Get IP address and set up server properties
SERVER_IP=$(hostname -I | awk '{print $1}')
SERVER_PORT=25565

# Update server properties
echo "Configuring server properties..."
cat > server.properties << EOF
server-port=$SERVER_PORT
server-ip=
enable-command-block=true
spawn-protection=16
max-tick-time=60000
query.port=$SERVER_PORT
generator-settings=
force-gamemode=false
allow-nether=true
enforce-whitelist=false
gamemode=survival
broadcast-console-to-ops=true
enable-query=false
player-idle-timeout=0
difficulty=easy
spawn-monsters=true
op-permission-level=4
pvp=true
snooper-enabled=true
level-type=default
hardcore=false
enable-rcon=false
max-players=20
network-compression-threshold=256
resource-pack-sha1=
max-world-size=29999984
rcon.port=25575
server-port=$SERVER_PORT
debug=false
server-ip=
spawn-npcs=true
allow-flight=false
level-name=world
view-distance=10
resource-pack=
spawn-animals=true
white-list=false
rcon.password=
generate-structures=true
online-mode=true
max-build-height=256
level-seed=
prevent-proxy-connections=false
motd=Welcome to Minecraft Server
enable-rcon=false
EOF

echo "=== Setup Complete! ==="
echo "Your Minecraft server has been installed and configured."
echo ""
echo "Server IP: $SERVER_IP"
echo "Server Port: $SERVER_PORT"
echo ""
echo "To start the server, run:"
echo "cd $SERVER_DIR && java -Xmx1024M -Xms1024M -jar server.jar nogui"
echo ""
echo "You may adjust the -Xmx and -Xms flags depending on your system's memory. -Xmx4096M and -Xms4096M is recommended."
echo "To make the server start automatically on boot, you may want to set up a systemd service."
echo "Remember to configure your firewall to allow connections on port $SERVER_PORT"
