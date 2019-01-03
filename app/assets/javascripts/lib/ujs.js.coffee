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

$(document).on "click", "[data-href]", (e) ->
    target = $(e.currentTarget)
    href   = target.data('href')
    window.location.href = href

$(document).on "ajax:success", "[data-remove-closest]", (e) ->
    target = $(e.target)
    remove_closest = $(e.target).data('remove-closest')

    target.closest(remove_closest).remove()

$(document).on "ajax:success", "[data-update-closest]", (e, response) ->
    target = $(e.target)
    update_closest = $(e.target).data('update-closest')

    target.closest(update_closest).replaceWith(response)

$(document).on "ajax:success", "[data-update-element]", (e, response) ->
    target = $(e.target)
    update_element = $(e.target).data('update-element')

    $(update_element).replaceWith(response)

$(document).on "ajax:success", "[data-redirect]", (e) ->
    target = $(e.target)
    data_redirect = $(e.target).data('data-redirect')

    window.location.replace(data_redirect)
