#!/usr/bin/python3

#Import the necessary modules
from mininet.net import Mininet
from mininet.node import Host, Switch
from mininet.cli import CLI
from mininet.log import setLogLevel, info
from mininet.nodelib import NAT

# Set the log level
setLogLevel('info')

# Create an instance of Mininet
net = Mininet()

# Create two hosts
h1 = net.addHost('h1',ip='10.0.0.10/24')
h2 = net.addHost('h2',ip='10.0.0.11/24')

# Create a switch
s1 = net.addSwitch('s1')

# Create NAT instance
nat = net.addNAT(ip='10.0.0.1/24').configDefault()

# Add links between hosts and switch
link1 = net.addLink(h1, s1)
link2 = net.addLink(h2, s1)

# Start the network
net.build()
net.start()

# Set the fail mode to standalone for switch s1
s1 = net.get('s1')
s1.cmd('ovs-vsctl set-fail-mode s1 standalone')

#Set default route for h1
h1.setDefaultRoute('via 10.0.0.1')

# Start the CLI
CLI(net)

# Stop the network
net.stop()