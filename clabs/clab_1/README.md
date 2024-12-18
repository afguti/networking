## CONTAINERLAB TOPOLOGY DEPLOYMENT AUTOMATION
---

This is a project to automate the deployment of a simple topology with **Containerlab**.

[diagram - pending]

We will first install containerlab in a python virtual environment.

1. We create a project forlder named clab_1
2. Inside the directory. We run `python3 -m venv clab1`
3. Then we spin up the virtual env with `source clab1/bin/activate`
4. We should see `(clab1)` at the beginning of our prompt now.
5. We will install **containerlab** in this environment.

#### Containerlab installation:
You can refer to the link below:
https://containerlab.dev/install/
It has **Quicksetup Script** that will install all the packages and dependencies you have, plus Containerlab.
I believe we just need Docker. If you have it already, then you can just run the **Intall Script** from the URL above.

#### Construction and deployment of the topology:
Once we have Containerlab installed we need to write the topology, which is a YAML file.

```
name: a
topology:
  nodes:
    R1:
      kind: linux
      image: alpine:latest
      exec:
        - ip address add 10.0.0.10/24 dev eth1
    R2:
      kind: linux
      image: alpine:latest
      exec:
        - ip address add 10.0.0.20/24 dev eth1

  links:
    - endpoints: ["R1:eth1", "R2:eth1"]
```
We can save this with the name `topology.yml`. Then we execute `containerlab deploy -t topology.yml`
We can verify this topology any time with `containerlab inspect -t topology.yml`. Also with `docker ps`
```
╭───────────┬───────────────┬─────────┬───────────────────╮
│    Name   │   Kind/Image  │  State  │   IPv4/6 Address  │
├───────────┼───────────────┼─────────┼───────────────────┤
│ clab-a-R1 │ linux         │ running │ 172.20.20.5       │
│           │ alpine:latest │         │ 3fff:172:20:20::5 │
├───────────┼───────────────┼─────────┼───────────────────┤
│ clab-a-R2 │ linux         │ running │ 172.20.20.4       │
│           │ alpine:latest │         │ 3fff:172:20:20::4 │
╰───────────┴───────────────┴─────────┴───────────────────╯
```
You can see that IPv4 is not 10.0.0.X. This is because this IP address assigned by default to th0. We can change that, but we will see it on a next lab.

#### Log in and verification
Now that we have the network deployed. We will log in into clab-a-R1 host and verify connectivity to clab-a-R2.
We log in into a device by executing `docker exec -it <host> sh`. So, we run `docker exec -it clab-a-R1 sh`. Once logged in we test reachability to R2 eth1, which is 10.0.0.24.
The test will look as follow
```
(clab1) user@mypc:~/clab_1$ docker exec -it clab-a-R1 sh
/ # 
/ # ping -c 3 10.0.0.20
PING 10.0.0.20 (10.0.0.20): 56 data bytes
64 bytes from 10.0.0.20: seq=0 ttl=64 time=0.327 ms
64 bytes from 10.0.0.20: seq=1 ttl=64 time=0.316 ms
64 bytes from 10.0.0.20: seq=2 ttl=64 time=0.256 ms

--- 10.0.0.20 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.256/0.299/0.327 ms
/ #
```
From here we can do lots sort of thing inside those Alpine boxes.


