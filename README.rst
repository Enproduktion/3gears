..
   Copyright (C) 2017 Enproduktion GmbH

   This file is part of 3gears.

   3gears is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.




========
 3gears
========

Collaborative video platform with extended metadata functionality.


Install Production Env
======================

3gears uses docker for deployment purposes and ansible for orchestration.

Local Requirements:
- ansible


1. Change config/environments/production.rb to your needs
2. Change rails_env in ansible/group_vars/production
2. All provisioning is done by ansible. Look at the ansible folders for all installation steps. For automatic provisioning run the following command:

.. code-block:: bash

   cd ansible
   ansible-playbook -i inventory prod.yml

Don't forget to change the application config files to your needs.


Install Development Env
=======================

3gears uses docker and vagrant for development purposes and ansible for orchestration.

Local Requirements:

- ansible
- vagrant

All provisioning is done by ansible. Look at the ansible folders for all installation steps. For automatic provisioning run the following command:

.. code-block:: bash

   vagrant up

The 3gears build task will fail on vagrant on it's first run. Just restart provisioning with "vagrant provision".

Don't forget to change the application config files to your needs.

To watch dev folder and auto sync, run:

.. code-block:: bash

   vagrant rsync-auto


Run Tests
---------

Stop docker stack and start the docker-dev stack to run the tests afterwards.
You may need to run twice.

.. code-block:: bash
    vagrant ssh
    cd /vagrant
    docker-compose -f docker-dev.yml up

    # For subsequent test runs, while docker-dev stack is running, do
    docker-compose -f docker-dev.yml run 3gears-test


Update 3gears
=============

.. code-block:: bash

   cd ansible
   ansible-playbook -i inventory update_3gears.yml
