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

class global.Flash
    constructor: (@element) ->
        global.Flash.instance = this
        @element.children().each (index, messageElement) =>
            messageElement = $(messageElement)
            time = parseInt(messageElement.attr("data-hide"))
            global.Flash._animate(messageElement, time)

    flash: (message, time) ->
        messageElement = $("<li/>")

        messageElement.text(message)
        messageElement.html(messageElement.html().replace("
", "<br>"))

        if time == 0
            hideButton = $("<button>X</button>")
            hideButton.addClass("button")
            hideButton.click ->
                global.Animation.hideFlash(messageElement, messageElement.remove)
            $("<br>").appendTo(messageElement)
            hideButton.appendTo(messageElement)

        messageElement.appendTo(@element)
        global.Flash._animate(messageElement, time)

    @flash: (message, time = 1000) ->
        @instance.flash(message, time)

    @error: (message, time = 0) ->
        @instance.flash(message, time)

    @_animate: (element, time) ->
        element.hide()
        global.Animation.showFlash(element)

ready = ->
    new global.Flash($("#flash"))

$(document).on('ready page:load', ready)
