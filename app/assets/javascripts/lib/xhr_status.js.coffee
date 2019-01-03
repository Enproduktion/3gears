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

global = window

delay = (time, func) -> setTimeout(func, time)

class global.XHRStatus
    @xhr_start: (xhr) ->
        @pending_requests += 1

        timer = delay 100, ->
            unless xhr.request_finished?
                $("#busy-indicator").show()

    @xhr_end = (xhr) ->
        xhr.request_finished = true

        @pending_requests -= 1
        if @pending_requests == 0
            $("#busy-indicator").hide()

    @pending_requests: 0
