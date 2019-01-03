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

class global.UserSuggest
    constructor: (@root) ->
        @user_input = @root.find("input.suggest-user")

        if @user_input[0]
            @user_input.autocomplete
                source: @user_input.attr("data-suggestions-path")
                minLength: 2
                select: (e, ui) =>
                    @_set_user(ui.item)
                    false

            @user_input.data("ui-autocomplete")._renderItem = (ul, item) ->
                element = $("<li/>")
                element.data("item.autocomplete", item)
                element.html("<a>" + item.view + "</a>")
                element.appendTo(ul)
                element

            @root.on "click", "button.user.delete", =>
                @_clear_user()
                false

    _set_user: (@userinfo) ->
        @user_input.val(@userinfo.username)

    _clear_user: ->
        @user_input.val("")

    reset: ->
        @_clear_user()
