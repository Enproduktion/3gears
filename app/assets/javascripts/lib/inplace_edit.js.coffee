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

init_editors = (resources) ->

  resources.each ->
    root = $(this)

    console.log('init_editor')

    submit_input = (input) ->
      send_data(root, input)

#   disable enter to submit
    root .on 'keydown', 'input', (event) ->
      that = $(this)
      if event.which == 13
        event.preventDefault()
#       find form inputs
        inputs = $(this).closest('form').find(':input')
#       find next input
        inputs.eq( inputs.index(that)+ 1 ).focus()

    root.on "change", ":input", ->
      that = $(this)
#      ignore inputs with file type
      if that.attr('type') != 'file'
        submit_input(that)

ready = ->
  init_editors($(document).find(".updateable-resources"))

$(document).on "ajax:success", (e, data, status, xhr) ->
  init_editors($(document).find(".updateable-resources"))

send_data = (form, input) ->
  resource_path = form.attr('action')
  field = input.attr('name')

  data = {}
  data[field] = input.val()

  $.ajax
    url: resource_path
    type: "PUT"
    data: data
    dataType: "json"
    success: (e, status, xhr) =>
      if /viewable_by_all/.test(field)
        $('#overlay-visibility').find('.visibility-message').find('.message').text(visibility_response(input.val()))
        $('#overlay-visibility').find('.visibility-message').show()

visibility_response = (value) ->
  switch value
    when '0'
      return "The Item is for your eyes only!"
    when '1'
      return "Item is visible for your team only!"
    when '2'
      return "Item is visible for all audiences!"

$(document).ready(ready)
$(document).on('page:load', ready)
