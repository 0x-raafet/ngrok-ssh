rm -rf ngrok ngrok.zip ngrok.sh > /dev/null 2>&1
wget -O ng.sh https://raw.githubusercontent.com/0x-raafet/openbullet_setup/main/ng.sh > /dev/null 2>&1
chmod +x ng.sh
./ng.sh
clear
echo "======================="
echo choose ngrok region
echo "======================="
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "choose ngrok region: " CRP
./ngrok tcp --region $CRP 22 &>/dev/null &
echo "======================="
echo Updating Please Wait
echo "======================="
sudo apt update > /dev/null 2>&1
sudo apt install openssh-server > /dev/null 2>&1
mkdir -p /var/run/sshd
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "LD_LIBRARY_PATH=/usr/lib64-nvidia" >> /root/.bashrc
echo "export LD_LIBRARY_PATH" >> /root/.bashrc
sudo service ssh start
echo "===================================="
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo create root password
passwd
echo "===================================="
echo "Installing Dotnet ..."
wget https://download.visualstudio.microsoft.com/download/pr/1cac4d08-3025-4c00-972d-5c7ea446d1d7/a83bc5cbedf8b90495802ccfedaeb2e6/dotnet-sdk-6.0.417-linux-x64.tar.gz > /dev/null 2>&1
mkdir -p $HOME/dotnet && tar zxf dotnet-sdk-6.0.417-linux-x64.tar.gz -C $HOME/dotnet > /dev/null 2>&1
export DOTNET_ROOT=$HOME/dotnet
export PATH=$PATH:$HOME/dotnet
git clone https://github.com/openbullet/OpenBullet2/  > /dev/null 2>&1
cd OpenBullet2/OpenBullet2
dotnet publish --configuration Release  > /dev/null 2>&1
cd bin/Release/net6.0/publish
nohup dotnet ./OpenBullet2.dll &>/dev/null &
nohup ./ngrok http 5000 &>/dev/null &
curl --silent --show-error http://127.0.0.1:4041/api/tunnels | sed -nE 's/.*public_url":"http:..([^"]*).*/\1/p'
