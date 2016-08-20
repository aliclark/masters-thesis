
# Starting from install.0.sh

apt-get install -y apt-transport-https
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-get update

apt-get install -y docker-engine

docker build -t shadow .
docker run shadow
