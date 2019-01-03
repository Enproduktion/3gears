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

class TagEditor
  constructor: (@element) ->
    @list = @element.find("ul")
    @resource_path = @element.attr("data-resource-path")
    @suggestions_path = @element.attr("data-suggestions-path")
    @placeholderText = @element.attr("data-placeholder")
    @readonly = @list.data('readonly') != undefined
    @placeholderText = if @readonly then null else @placeholderText

    @list.tagit
      placeholderText: @placeholderText
      readOnly: @readonly
      allowSpaces: true
      delimiterKeyCode: 186
      removeConfirmation: true
      autocomplete:
        source: @suggestions_path
      beforeTagAdded: (evt, ui) =>
        if (!ui.duringInitialization)
          $.ajax
            url: @resource_path
            type: "POST"
            data:
              "tag[name]": ui.tagLabel
            dataType: "json"
            error: (xhr, a) =>
              global.ErrorHelper.showXhrError(xhr)
            beforeSend: (xhr) ->
              global.XHRStatus.xhr_start(xhr)
              true
            complete: (xhr) ->
              global.XHRStatus.xhr_end(xhr)
      beforeTagRemoved: (evt, ui) =>
        url = @resource_path + '/' + encodeURI(ui.tagLabel)
        $.ajax
          url: url
          type: "DELETE"
          dataType: "json"
          error: (xhr, a) =>
            global.ErrorHelper.showXhrError(xhr)
          beforeSend: (xhr) ->
            global.XHRStatus.xhr_start(xhr)
            true
          complete: (xhr) ->
            global.XHRStatus.xhr_end(xhr)

ready = ->
  $(".tag-area").each ->
    new TagEditor($(this))

$(document).ready(ready)
$(document).on('page:load', ready)
