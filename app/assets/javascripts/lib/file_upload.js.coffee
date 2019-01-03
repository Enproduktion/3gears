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

ready = ->

    $("form.file-upload").each ->
        root = $(this)

        root.on "change", "input", (e) =>
          if e.type is "drop"
            e.preventDefault()
            $(this).prop("files", e.originalEvent.dataTransfer.files);
          root.submit()
          $(e.target).replaceWith($(e.target).clone(true))

    image_upload $('#user_avatar_upload'), '.user__header__avatar'
    image_upload $('#user_picture_upload'), '.user__header'
    image_upload $('#organisation_avatar_upload'), '.organisation__header__avatar'
    image_upload $('#organisation_cover_upload'), '.organisation__header'

image_upload = (form, replaceClass) ->
    form.on 'ajax:success', (e, response, status, xhr) ->
        response = $(xhr.responseText).find(replaceClass)
        $(replaceClass).replaceWith(response)

    form.on 'ajax:error', (e, response, status, xhr) ->
        alert 'Failed to change avatar'

$(document).ready(ready)
$(document).on('page:load', ready)
