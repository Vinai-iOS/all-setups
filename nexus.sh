# Update system
sudo yum update -y
sudo yum install wget -y

# Install correct Java (full JDK, not jmods)
sudo yum install java-17-amazon-corretto -y

# Create app directory and download Nexus
sudo mkdir -p /app && cd /app
sudo wget https://download.sonatype.com/nexus/3/nexus-3.79.1-04-linux-x86_64.tar.gz
sudo tar -xvf nexus-3.79.1-04-linux-x86_64.tar.gz
sudo mv nexus-3.79.1-04 nexus

# Create nexus user
sudo adduser nexus

# Set correct permissions
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work

# Correct run_as_user in nexus.rc
sudo sed -i 's/^#run_as_user=""/run_as_user="nexus"/' /app/nexus/bin/nexus.rc

# Create systemd service file
sudo tee /etc/systemd/system/nexus.service > /dev/null << EOL
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus





#sudo yum update -y
#sudo yum install wget -y
#sudo yum install java-17-amazon-corretto-jmods -y
#sudo mkdir /app && cd /app
#sudo wget https://download.sonatype.com/nexus/3/nexus-3.79.1-04-linux-x86_64.tar.gz
#sudo tar -xvf nexus-3.79.1-04-linux-x86_64.tar.gz
#sudo mv nexus-3.79.1-04 nexus
#sudo adduser nexus
#sudo chown -R nexus:nexus /app/nexus
#sudo chown -R nexus:nexus /app/sonatype*
#sudo sed -i '27  run_as_user="nexus"' /app/nexus/bin/nexus
#sudo tee /etc/systemd/system/nexus.service > /dev/null << EOL
#[Unit]
#Description=nexus service
#After=network.target

#[Service]
#Type=forking
#LimitNOFILE=65536
#User=nexus
#Group=nexus
#ExecStart=/app/nexus/bin/nexus start
#ExecStop=/app/nexus/bin/nexus stop
#User=nexus
#Restart=on-abort

#[Install]
#WantedBy=multi-user.target
#EOL
#sudo chkconfig nexus on
#sudo systemctl start nexus
#sudo systemctl enable nexus
#sudo systemctl status nexus
