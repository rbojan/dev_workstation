# Bootstrap Developer Workstation: User scripts

## Global Config
source /vagrant/config

## Local config

## SSH
mkdir -p ~/.ssh/
echo $PUBLIC_KEY > ~/.ssh/authorized_keys

## GitLab CLI
sudo gem install gitlab

if [ -f ~/.gitlab ]; then
   echo "GitLab CLI config (.gitlab) already exists."
else
   tee ~/.gitlab >/dev/null <<EOF
GITLAB_API_ENDPOINT=https://gitlab.veb.audi-connect.de/api/v3
GITLAB_API_PRIVATE_TOKEN=XXX
EOF
fi

echo 'export $(cat .gitlab | xargs)' >> ~/.bashrc

echo 'source <(helm completion bash)' >> ~/.bashrc
echo 'source <(kubectl completion bash)' >> ~/.bashrc
