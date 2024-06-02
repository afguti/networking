#!/usr/bin/python3
#Import the necessary modules
from mininet.net import Mininet
from mininet.node import Host, Switch
from mininet.cli import CLI
from mininet.log import setLogLevel, info

# Set the log level
setLogLevel('info')

# Create an instance of Mininet
net = Mininet()

# Create two hosts
h1 = net.addHost('h1')
h2 = net.addHost('h2')

# Create a switch
s1 = net.addSwitch('s1')

# Add links between hosts and switch
link1 = net.addLink(h1, s1)
link2 = net.addLink(h2, s1)

# Start the network
net.start()

# Set the fail mode to standalone for switch s1
s1 = net.get('s1')
s1.cmd('ovs-vsctl set-fail-mode s1 standalone')

# Get the interface names for the hosts
h1_intf = h1.defaultIntf()
h2_intf = h2.defaultIntf()

# Ping h2 from h1
info('Pinging h2 from h1...\n')
h1.cmdPrint('ping -c 3', h2.IP(h2_intf))

# Stop the network
net.stop()