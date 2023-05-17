#!/bin/bash
sudo yum install nginx git -y &&
#cd /usr/share/nginx/html/
#sudo git clone https://github.com/sample-repo/my-app.git
sudo systemctl enable nginx &&
sudo systemctl start nginx