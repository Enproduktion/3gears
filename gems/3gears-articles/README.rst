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


***************
3gears-articles
***************

Allow and administer blog-style articles in 3gears.

Getting Started
===============

Build the gem:

.. code-block:: bash

	gem build 3gears-articles.gemspec


Install the gem locally:

.. code-block:: bash

	gem install 3gears-articles-0.1.0.gem


Add to your gemfile with:

.. code-block:: ruby

	gem '3gears-articles', '~> 0.1.0'


Run the bundle command to install it.

After you install article doxx and add it to your Gemfile, you need to run the generator:

.. code-block:: bash

	rails generate article


Then add to config/routes.rb:

.. code-block:: ruby

	resources :articles


Or with scope locale:

.. code-block:: ruby

	scope ":locale", locale: /en|id/ do
	  	resources :articles
	end



Current dependencies on 3gears
==============================

* default controller
* default view
* user who create the article 

Reason
------

* Controller use another dependency (cancancan) and the view is dynamic
