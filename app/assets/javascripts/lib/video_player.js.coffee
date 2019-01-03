###
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
###

change = ->
    console.log('VIDEO PAGE CHANGED')

    for player in document.getElementsByClassName 'video-js'
        video = videojs('example_video')

before_change = ->
    console.log('VIDEO PAGE ABOUT TO CHANGE')
    for player in document.getElementsByClassName 'video-js'
        video = videojs('example_video')
        video.dispose()

$(document).on('page:before-change', before_change)
$(document).on('page:change', change)
$(document).on('page:before-unload', before_change)
