
# Starting from Debian Jessie

apt-get update

# How to not show the cron message?
#apt-get upgrade -y

apt-get install -y git

git clone https://github.com/aliclark/masters-thesis

cd masters-thesis/shadow-tor-docker/
./install.1.sh
