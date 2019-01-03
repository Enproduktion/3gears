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

class LanguageSwitcher
  constructor: (@element) ->
    @set_language(@element.val())
    @element.change(@change)

  change: =>
    @set_language(@element.val())

  set_language: (language) ->
    $('.language_switcher').hide()
    $('.language_switcher_' + language).show()

ready = ->
  $("select.language").each ->
    new LanguageSwitcher($(this))

$(document).ready(ready)
$(document).on('page:load', ready)
