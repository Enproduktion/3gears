# coding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Copyright (C) 2017 Enproduktion GmbH
#
# This file is part of 3gears.
#
# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "bento/debian-8.8"
    config.vm.box_check_update = false

    config.vm.network "forwarded_port", guest: 3000, host: 3000
    config.vm.network "forwarded_port", guest: 4567, host: 4567
    config.vm.network "forwarded_port", guest: 4568, host: 4568
    config.vm.network "forwarded_port", guest: 9000, host: 9000

    config.vm.network :private_network, ip: '192.168.55.55'


    # config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder '.', '/vagrant', type: "rsync"

    config.vm.network :forwarded_port, guest: 22, host: 2323, id: 'ssh'

    config.vm.provider "virtualbox" do |v|
      host = RbConfig::CONFIG['host_os']

      # Give VM 1/4 system memory & access to all cpu cores on the host
      if host =~ /darwin/
        cpus = [`sysctl -n hw.ncpu`.to_i/2, 1].max
        # sysctl returns Bytes and we need to convert to MB
        mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
      elsif host =~ /linux/
        cpus = `nproc`.to_i
        # meminfo shows KB and we need to convert to MB
        mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
      else # sorry Windows folks, I can't help you
        cpus = 2
        mem = 1024
      end

      v.customize ["modifyvm", :id, "--memory", mem]
      v.customize ["modifyvm", :id, "--cpus", cpus]
    end

    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/dev.yml"
      ansible.sudo = true
      # ansible.verbose = true
      # ansible.start_at_task = ""
    end

end
