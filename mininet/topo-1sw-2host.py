#!/usr/bin/python3

# Import the necessary modules
from mininet.net import Mininet
from mininet.node import OVSSwitch
from mininet.cli import CLI
from mininet.log import setLogLevel, info
import time
import subprocess

# Set the log level
setLogLevel('info')

# Create an instance of Mininet
net = Mininet()

# Create two hosts
h1 = net.addHost('h1')
h2 = net.addHost('h2')

# Create a switch
s1 = net.addSwitch('s1', cls=OVSSwitch)

# Add links between hosts and switch
net.addLink(h1, s1)
net.addLink(h2, s1)

# Start the network
net.start()

# Set the fail mode to standalone for switch s1
s1.cmd('ovs-vsctl set-fail-mode s1 standalone')

# Get the interface names for the hosts
h1_intf = h1.defaultIntf()
h2_intf = h2.defaultIntf()

# Start tcpdump in the background on h1
info('Starting tcpdump on h1...\n')
h1.cmd('tcpdump icmp -w /tmp/output.pcap &')

# Ping h2 from h1
info('Pinging h2 from h1...\n')
h1.cmdPrint('ping -c 2 %s' % h2.IP())

# Stop tcpdump by killing the background process
info('Stopping tcpdump on h1...\n')
h1.cmd('pkill -f "tcpdump icmp -w /tmp/output.pcap"')
# Ensure the tcpdump process is terminated
time.sleep(1)

# Check if the pcap file was created
pcap_check = h1.cmd('ls -l /tmp/output.pcap')
print("PCAP file check:\n", pcap_check)

# Stop the network
net.stop()

# Example command
command = "tcpdump -r /tmp/output.pcap"

# Run the command and capture its output
result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

# Print the output
print(f"Output:\n{result.stdout}")

# Print any errors, if they occur
if result.stderr:
    print("Errors:", result.stderr)

#Removing output pcap file
command = "rm /tmp/output.pcap"
result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
