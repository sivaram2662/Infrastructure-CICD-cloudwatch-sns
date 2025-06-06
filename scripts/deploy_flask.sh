#!/bin/bash
sudo yum install -y awslogs
sudo systemctl start awslogsd
sudo systemctl enable awslogsd
sudo yum update -y
sudo yum install -y python3 git
pip3 install flask

cat <<EOF > /home/ec2-user/app.py
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return "Hello Bastion"
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
EOF

nohup python3 /home/ec2-user/app.py &
