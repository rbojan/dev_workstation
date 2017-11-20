# Bootstrap Developer Workstation

## Global Config
source /vagrant/config

DOCKER_VERSION=17.06.2
DOCKER_COMPOSE_VERSION=1.17.1
TERRAFORM_VERSION=0.11.0
PACKER_VERSION=1.1.2
VAULT_VERSION=0.9.0

## Prerequisites

### Update & upgrade
apt-get update && apt-get upgrade

### Global
apt-get install -y wget curl git unzip ruby

echo "--- Installing Go ... "
apt-get install -y --no-install-recommends golang
mkdir -p /usr/lib/go
echo "GOPATH=/usr/lib/go" >> v

echo "--- Installing Java ... "
add-apt-repository ppa:webupd8team/java
apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get install -y oracle-java8-installer
echo "LANG=C.UTF-8" >> /etc/environment
echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/environment

echo "--- Installing Python ... "
apt-get install -y python3-pip python3-setuptools build-essential python3-dev python-ldap

## Install packages
echo "--- Installing Docker ... "
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update && apt-get install -y --no-install-recommends docker-ce=${DOCKER_VERSION}~ce-0~ubuntu

echo "--- Installing Docker compose ... "
curl -s -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "--- Installing Terraform ... "
wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin

echo "--- Installing Packer ... "
wget --quiet https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin

echo "--- Installing Vault ... "
wget --quiet https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
unzip vault_${VAULT_VERSION}_linux_amd64.zip -d /usr/local/bin

echo "--- Installing Ansible ... "
# http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-apt-ubuntu
apt-get install -y --no-install-recommends software-properties-common
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
apt-get update
apt-get install -y --no-install-recommends ansible python-boto

## Add group autonubil & user
groupadd autonubil
useradd -m -s /bin/bash -G autonubil $USER
echo "%${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

# Skip installing gem documentation
echo 'gem: --no-rdoc --no-ri' >> /etc/gemrc

## User script
su -c "source /vagrant/bootstrap-user.sh" $USER
