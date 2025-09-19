#!/bin/bash

vagrant plugin install vagrant-vbguest

(cd VirtualMachines/DDoSAttacker && vagrant up )
(cd VirtualMachines/DDoSTarget && vagrant up )
