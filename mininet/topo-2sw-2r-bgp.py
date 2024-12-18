#Import the necessary modules
from mininet.net import Mininet
from mininet.node import Host, Switch
from mininet.cli import CLI
from mininet.log import setLogLevel, info

# Set the log level
setLogLevel('info')

# Create an instance of Mininet
net = Mininet()

# Create routers
r1 = net.addHost('r1')

# Create hosts
h1 = net.addHost('h1')

# Add links between hosts and switch
link1 = net.addLink(h1, r1)

net.start()

"""
    # Configure FRR on routers
    r1.cmd('/usr/lib/frr/bgpd')
    r2.cmd('/usr/lib/frr/bgpd')

    # Wait for FRR to start
    waitListening(server=r1, port=2601)
    waitListening(server=r2, port=2601)

    # Configure BGP on routers
    r1.cmd('vtysh -c "conf t" -c "router bgp 65001" -c "bgp router-id 10.0.0.1" -c "neighbor 10.0.1.1 remote-as 65002"')
    r2.cmd('vtysh -c "conf t" -c "router bgp 65002" -c "bgp router-id 10.0.1.1" -c "neighbor 10.0.0.1 remote-as 65001"')
"""
# Start the CLI
CLI(net)

# Stop the network
net.stop()