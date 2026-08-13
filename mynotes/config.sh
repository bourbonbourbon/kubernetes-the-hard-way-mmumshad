#!/bin/env bash
apt install open-vm-tools sudo

usermod -aG sudo john

# sudo tee -a /etc/bash.bashrc >/dev/null << 'EOF'
# export HISTSIZE=100000
# export HISTFILESIZE=200000
# shopt -s histappend
# export PROMPT_COMMAND='history -a; history -c; history -r'
# export HISTCONTROL=ignoredups:erasedups:ignorespace
# EOF

sudo tee -a $HOME/.ssh/config >/dev/nul << 'EOF'
Host k8sjumpbox
    Hostname 172.16.134.144
    User john
    IdentityFile /home/bourbon/.ssh/k8s
    IdentitiesOnly yes
    AddKeysToAgent yes

Host k8sserver
    Hostname 172.16.134.145
    User john
    IdentityFile /home/bourbon/.ssh/k8s
    IdentitiesOnly yes
    AddKeysToAgent yes

Host k8snode-0
    Hostname 172.16.134.146
    User john
    IdentityFile /home/bourbon/.ssh/k8s
    IdentitiesOnly yes
    AddKeysToAgent yes

Host k8snode-1
    Hostname 172.16.134.147
    User john
    IdentityFile /home/bourbon/.ssh/k8s
    IdentitiesOnly yes
    AddKeysToAgent yes
EOF

# tee "$HOME/.tmux.conf" >/dev/null << 'EOF'
# set -g mouse on
# EOF

mkdir -p "$HOME/ansible/playbooks"

tee "$HOME/ansible/inventory" >/dev/null << 'EOF'
[all]
k8sjumpbox
k8sserver
k8snode-0
k8snode-1
EOF

tee "$HOME/ansible/playbooks/bash-config.yaml" >/dev/null << 'EOF'
---
- name: Add exit alias to global bashrc
  hosts: all
  become: yes
  tasks:
    - name: Ensure alias e='exit' is present in /etc/bash.bashrc
      ansible.builtin.lineinfile:
        path: /etc/bash.bashrc
        line: "alias e='exit'"
        state: present
EOF

sudo apt update -y

cp /vagrant/ubuntu/vagrant/install-guest-additions.sh /tmp

cd /tmp || exit

sudo bash install-guest-additions.sh

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo 'tmux|screen|' > .bashrc
