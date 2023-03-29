cd /etc/systemd/system
echo "Starting Care.Chain service..."
echo "
	[Unit]
	Description=Care.Chain  Node 
	[Service]
	Type=simple
	Restart=always
	RestartSec=1
	User=$USER
	Group=$USER
	LimitNOFILE=4096
	WorkingDirectory=/home/validator

	ExecStart=carechainnode server --data-dir ./data-dir --chain ./genesis.json  --grpc 0.0.0.0:9632 --libp2p 0.0.0.0:1478 --jsonrpc 0.0.0.0:8545 --nat 159.89.54.205 --seal
	[Install]
	WantedBy=multi-user.target
" | sudo tee carechain.service

if grep -q ForwardToSyslog=yes "/etc/systemd/journald.conf"; then
  sudo sed -i '/#ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
  sudo sed -i '/ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
elif ! grep -q ForwardToSyslog=no "/etc/systemd/journald.conf"; then
  echo "ForwardToSyslog=no" | sudo tee -a /etc/systemd/journald.conf
fi
cd -
echo

# Start systemd Service
sudo systemctl force-reload systemd-journald
sudo systemctl daemon-reload
sudo systemctl start carechain.service

read -n 1 -s -r -p "Service successfully started! Press any key to continue..."
echo
