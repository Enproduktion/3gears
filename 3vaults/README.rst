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


=========
 3vaults
=========

File storage for 3gears.


Create Dockerfile.lock
======================

    docker run --rm -v "$PWD/src":/app -w /app ruby:2.3-alpine bundle install

==========
 Building
==========

Create docker images
====================

.. code-block:: bash
    docker build -t "ffmpeg" docker/ffmpeg
    docker-compose build


Create bucket and make it world readable
========================================

    Do after running

.. code-block:: bash
    # wget https://dl.minio.io/client/mc/release/linux-amd64/mc
    # chmod +x mc
    mc config host add s3 http://localhost:9000 ACCESS_KEY ACCESS_SECRET
    mc mb s3/3vaults
    mc policy download s3/3vaults

=====
 Run
=====

    docker-compose up

==============
 Architecture
==============

There are three components:

:core: Orchestrates uploads
:transcoder: Transcodes media
:receiver: Handles upload

Uploading and Transcoding a Video
=================================

1. The client announces the upload to the frontend.
2. The frontend create an upload ticket (POST core/tickets).
3. The client uploads the file to the receiver.
4. The client notifies the frontend about upload completion.
5. The frontend moves the uploaded file to "originals" storage (PUT core/files/id).
6. The frontend publishes the file (PUT core/files/id).
7. The frontend requests medium information (GET core/mediuminfo/id).
8. The frontend starts video transcoding (POST core/transcodings).
9. The frontend polls transcoding status (GET core/transcodings).
10. The frontend publishes the transcoding result (PUT core/files/id).

Published files are currently served by the receiver. They are optionally uploaded to s3.

Testing
=======

    curl -i -u : -X POST http://localhost:4567/tickets -d size=1
    curl -i -u : -X PUT http://localhost:4567/files/ -d move_to=local
    curl -i -u : -X PUT http://localhost:4567/files/ -d publish_as=huhu.jpg
    curl -i -u : -X PUT http://localhost:4567/files/ -d move_to=remote
    curl -i -u :var:  -X DELETE http://localhost:4567/files/
