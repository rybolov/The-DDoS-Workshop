# The-DDoS-Workshop
Resources for our DDoS workshop

### Setting Up


#### Set up an Environment
Install VirtualBox https://www.virtualbox.org/
Install Vagrant https://developer.hashicorp.com/vagrant/docs/installation

#### Clone this project
`git clone https://github.com/rybolov/The-DDoS-Workshop.git`

#### Make the Virtual Machines

Linux: `bash ./setup.sh`

Windows: From a command line, run `setup.bat`

#### Log in to Virtual Machines

Username: `vagrant` Password:`ddos`

Sudo works if you need to change.

#### Testing Your Setup

Each VM should have a NAT interface on a network such as 10.0.2.0/24.
DDoS Target will have a single interface on a host-only adapter as 192.168.56.2. There should be a simple website on that IP address.


DDoS Attacker will have a single interface on a host-only adapter as 192.168.56.3 plus aliases on that interface from 192.168.56.4 to 192.168.56.254. This gives us a lot of IP addresses that we can launch attacks from.

### Launch Some Attacks from DDoS Attacker!!!

`asdf`