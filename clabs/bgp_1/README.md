# Three way handshake lab
---
This lab is to demonstrate the TCP 3 way handshake protocol sequence. We will setup an HTTP server and a CLIENT. Both are running Linux Alpine.

[FIGURE]

Once networking repository is clonned, go to `clabs/3way`. There you'll find all the packets you need. Here we run `. setup.sh`. This will setup some env variables to save us some time tipying. We run `begin` to start the lab.
Once this is done, we deploy our topology with `deploy` command. From there we can log in into CLIENT and SERVER, using the command `get`. For example to log in into SERVER `get server` should do it.

```yaml
name: simple
topology:
  nodes:
    CLIENT:
      kind: linux
      image: alpine:latest
      exec:
        - ip address add 10.0.0.10/24 dev eth1
        - apk update
        - apk add tcpdump
      binds:
        - scripts/lab_client.sh:/tmp/lab_client.sh
    SERVER:
      kind: linux
      image: alpine:latest
      exec:
        - ip address add 10.0.0.20/24 dev eth1
        - apk update
        - apk add python3
      binds:
        - ./scripts/lab_server.sh:/tmp/lab_server.sh

  links:
    - endpoints: ["SERVER:eth1", "CLIENT:eth1"]
```

Once in the server you can start an HTTP server with python. As you can see in the topology above, SERVER should have python3 already installed. You can also run `. tmp/lab_server.sh` to get the server set up for you. But I encorage you to try yourself first. Once the HTTP server is runnign you can verify with `ps` and `netstat`.
Once the SERVER is done, we can log into CLIENT, and connet to the HTTP server to download the html file, and capture packets with `tcpdump` to visualize the **3 way handshake**.
Same as with the SERVER, you can run `. tmp/lab_client.lab` to run all the commands you need. But try yourself first.
### The output should be similar as below:
There we can see the first three packets are the 3 way handshake protol in action. Then we have the exchange of information between the SERVER and CLIENT, and the last three packets is the teardown process of the connection.
```bash
reading from file ./capture.pcap, link-type EN10MB (Ethernet), snapshot length 262144
07:37:32.535896 IP 10.0.0.10.59786 > 10.0.0.20.8000: Flags [S], seq 2155205640, win 56760, options [mss 9460,sackOK,TS val 3344611705 ecr 0,nop,wscale 7], length 0
07:37:32.536023 IP 10.0.0.20.8000 > 10.0.0.10.59786: Flags [S.], seq 949732925, ack 2155205641, win 56688, options [mss 9460,sackOK,TS val 1010948330 ecr 3344611705,nop,wscale 7], length 0
07:37:32.536110 IP 10.0.0.10.59786 > 10.0.0.20.8000: Flags [.], ack 1, win 444, options [nop,nop,TS val 3344611705 ecr 1010948330], length 0
07:37:32.536425 IP 10.0.0.10.59786 > 10.0.0.20.8000: Flags [P.], seq 1:78, ack 1, win 444, options [nop,nop,TS val 3344611705 ecr 1010948330], length 77
07:37:32.536484 IP 10.0.0.20.8000 > 10.0.0.10.59786: Flags [.], ack 78, win 443, options [nop,nop,TS val 1010948330 ecr 3344611705], length 0
07:37:32.544196 IP 10.0.0.20.8000 > 10.0.0.10.59786: Flags [P.], seq 1:157, ack 78, win 443, options [nop,nop,TS val 1010948338 ecr 3344611705], length 156
07:37:32.544297 IP 10.0.0.10.59786 > 10.0.0.20.8000: Flags [.], ack 157, win 443, options [nop,nop,TS val 3344611713 ecr 1010948338], length 0
07:37:32.544501 IP 10.0.0.20.8000 > 10.0.0.10.59786: Flags [P.], seq 157:1005, ack 78, win 443, options [nop,nop,TS val 1010948338 ecr 3344611713], length 848
07:37:32.544548 IP 10.0.0.10.59786 > 10.0.0.20.8000: Flags [.], ack 1005, win 490, options [nop,nop,TS val 3344611713 ecr 1010948338], length 0
07:37:32.544849 IP 10.0.0.20.8000 > 10.0.0.10.59786: Flags [F.], seq 1005, ack 78, win 443, options [nop,nop,TS val 1010948339 ecr 3344611713], length 0
07:37:32.545277 IP 10.0.0.10.59786 > 10.0.0.20.8000: Flags [F.], seq 78, ack 1006, win 490, options [nop,nop,TS val 3344611714 ecr 1010948339], length 0
07:37:32.545405 IP 10.0.0.20.8000 > 10.0.0.10.59786: Flags [.], ack 79, win 443, options [nop,nop,TS val 1010948339 ecr 3344611714], length 0
```
