#!/bin/bash
#
# Bootstrap script for prepping a minmal CentOS 7 install for dev
# Run with sudo 

if [ "$UID" -ne "0" ]; then
  echo "You must run this with root privileges. Please re-run with sudo."
  exit 1;
fi

yum -y update
yum -y install epel-release

yum install -y \
  python-pip \
  python-devel \
  python-virtualenv \
  libxml2-devel \
  libxml2-python \
  libxslt-devel \
  libxslt-python.x86_64 \
  gcc \
  git


groupadd --system fir
useradd --system --gid fir --home-dir /home/fir --shell /sbin/nologin --comment "FIR user" fir

rsync -av /vagrant/ /home/fir
chown -R fir:fir /home/fir
cd /home/fir
pip install -r requirements.txt

sudo -s -u fir
cd /home/fir
./manage.py migrate 
./manage.py loaddata incidents/fixtures/seed_data.json
./manage.py loaddata incidents/fixtures/dev_users.json

cat << EOF
┌────────────────────────────────────────────────────────────────────────────┐
│                                                                            │
│                                                                            │
│               _______ _____  ______     ______  _______ _    _             │
│               |______   |   |_____/ ___ |     \ |______  \  /              │
│               |       __|__ |    \_     |_____/ |______   \/               │
│                                                                            │
│                                                                            │
│  Provioning complete.                                                      │
│  Run the development server with:                                          │
│    sudo -s -u fir                                                          │
│    cd /home/fir; ./manage.py runserver 0.0.0.0:8000                        │
│  Login with development username/password:  admin/admin or dev/dev         │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
EOF
