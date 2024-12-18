#!/usr/bin/python3
from mininet.net import Mininet
from mininet.node import OVSSwitch
from mininet.cli import CLI
from mininet.log import setLogLevel, info
import time
import subprocess

setLogLevel('info')

# Create an instance of Mininet
net = Mininet()

h1 = net.addHost('h1')
h2 = net.addHost('h2')
s1 = net.addSwitch('s1', cls=OVSSwitch)

net.addLink(h1, s1)
net.addLink(h2, s1)

net.start()

s1.cmd('ovs-vsctl set-fail-mode s1 standalone')

# Start tcpdump in the background on h1
info('Starting tcpdump on h1...\n')
h1.cmd('tcpdump icmp -w /tmp/output.pcap &')

# Ping h2 from h1
info('Pinging h2 from h1...\n')
h1.cmdPrint('ping -c 2 %s' % h2.IP())

# Stop tcpdump by killing the background process
info('Stopping tcpdump on h1...\n')
h1.cmd('pkill -f "tcpdump icmp -w /tmp/output.pcap"')
time.sleep(1)

# Stop the network
net.stop()

#Display tcpdump
command = "tcpdump -r /tmp/output.pcap"
result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
print(f"Output:\n{result.stdout}")
if result.stderr:
    print("Errors:", result.stderr)

#Removing output pcap file
command = "rm /tmp/output.pcap"
result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
