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

class Uploader
    constructor: (@element) ->
        @element = $(@element)

        @controllerUri = @element.attr("data-controller")
        @id = @element.attr("data-id")

        @element.find("input").change (e) =>
            @_start(e.target.files[0])
            $(e.target).replaceWith $(e.target).clone(true) # clear file input value

        @element.bind "dragover", (e) =>
            false
        @element.find(".drop_target").bind "dragenter", (e) =>
            @element.find(".drop_target").addClass "drag_over"
        @element.find(".drop_target").bind "dragleave", (e) =>
            @element.find(".drop_target").removeClass "drag_over"
        @element.find(".drop_target").bind "dragend", (e) =>
            @element.find(".drop_target").removeClass "drag_over"
        @element.find(".drop_target").bind "drop", (e) =>
            @element.find(".drop_target").removeClass "drag_over"
            # check for number of files
            @_start(e.originalEvent.dataTransfer.files[0])

        @element.find(".pause").click =>
            @_pause()
        @element.find(".resume").click =>
            @_resume()

        @element.find(".busy_indicator").hide()
        @_showAsIdle()

    _start: (file) ->
        return if @_isRunning() || @requestPending

        if file.size == 0
            alert(I18n.t "uploader.file_is_empty")
            return

        @file = file

        @_xhrStarted()
        $.ajax
            url: @controllerUri + "/" + @id
            type: "PUT"
            data:
                'medium[original_filename]': @file.name
                'medium[filesize]': @file.size
                'medium[mime]': @file.type
            dataType: "json"
            success: (response) =>
                @_xhrCompleted()
                @uploadUri = response
                @_getPositionAndPerformUpload()
            error: (xhr) =>
                @_xhrFailed(xhr)

    _getPositionAndPerformUpload: ->
        @_xhrStarted()
        $.ajax
            url: @uploadUri
            dataType: "text"
            cache: false
            success: (response) =>
                @_xhrCompleted()
                @uploadPosition = parseInt(response)
                @_performUpload(@uploadPosition)
            error: (xhr) =>
                @_showAsPaused()
                @_xhrFailed xhr

    _performUpload: (@start) ->
        if @start >= @file.size
            @_uploadFinished()
            return

        if !@file.webkitSlice? and !@file.mozSlice?
            @start = 0
            @element.find(".pause").hide()

        if @start != 0
            if @file.webkitSlice?
                part = @file.webkitSlice @start
            else if @file.mozSlice?
                part = @file.mozSlice @start
        else
            part = @file

        @uploadPosition = @start
        @_updateProgressBar()

        @uploadXhr = new XMLHttpRequest()
        @uploadXhr.open("POST", @uploadUri + "start=" + @start, true)
        @uploadXhr.setRequestHeader("Content-Type", "application/octet-stream")

        @uploadXhr.onload = (e) =>
            if e.target.status != 200
                @_destroyXhr()
                @_showAsPaused()
                @_xhrFailed e.target
                return
            @uploadPosition = @start + parseInt(e.target.responseText)
            @_destroyXhr()
            @_updateProgressBar()
            if @uploadPosition == @file.size
                @_uploadFinished()
            else
                @_showAsPaused()

        @uploadXhr.onerror = (e) =>
            @_destroyXhr()
            @_showAsPaused()
            @_xhrFailed e.target

        @uploadXhr.onabort = (e) =>
            @_destroyXhr()
            @_showAsPaused()

        @uploadXhr.upload.onprogress = (e) =>
            @uploadPosition = @start + e.loaded
            @_updateProgressBar()

        @uploadXhr.send part
        @_showAsRunning()

    _uploadFinished: ->
        # now tell the controller
        @_xhrStarted()
        $.ajax
            url: @controllerUri + "/" + @id
            type: "PUT"
            data:
                "medium[ready]": "true"
            dataType: "text"
            success: (response) =>
                @completed = true
                @_showAsCompleted()
                @_xhrCompleted()
            error: (xhr) =>
                @_showAsPaused()
                @_xhrFailed xhr

    _pause: ->
        return if @requestPending
        @uploadXhr?.abort()

    _resume: ->
        return if @requestPending
        if @file
            @_getPositionAndPerformUpload()
        else
            global.Flash.flash(I18n.t "uploader.reselect_files")

    _isRunning: ->
        return !!@uploadXhr

    _showAsIdle: ->
        @element.attr("class", "uploader idle")
        @_updateProgressBar()

    _showAsRunning: ->
        @element.attr("class", "uploader running")
        @_updateProgressBar()

    _showAsPaused: ->
        @element.attr("class", "uploader paused")
        @_updateProgressBar()

    _showAsCompleted: ->
        @element.attr("class", "uploader completed")
        @_updateProgressBar()
        setTimeout ->
            location.reload()
          , 500

    _destroyXhr: ->
        @uploadXhr.onload = null
        @uploadXhr.onerror = null
        @uploadXhr.onabort = null
        @uploadXhr.upload.onprogress = null
        @uploadXhr = null

    _xhrStarted: ->
        @requestPending = true
        @_updateProgressBar()
        @element.find(".busy_indicator").fadeIn()
        @element.find("input").hide()

    _xhrCompleted: ->
        @requestPending = false
        @_updateProgressBar()
        @element.find(".busy_indicator").fadeOut()
        @element.find("input").show()

    _xhrFailed: (xhr) ->
        @requestPending = false
        global.ErrorHelper.showXhrError(xhr)
        @element.find(".busy_indicator").hide()
        @element.find("input").show()

    _updateProgressBar: ->
        if @completed
            progress = 100
            value = I18n.t "uploader.completed"
        else if @uploadPosition?
            progress = Math.floor(@uploadPosition / @file.size * 100)
            value = progress + " %"
        else
            progress = 0
            value = ""
        @element.find(".progress_bar_scale").width(progress + "%")
        @element.find(".progress_bar_value").text(value)

    requestPending: false
    completed: false

ready = ->
    $(".uploader").each (index, element) ->
        new Uploader(element)

$(document).ready(ready)
$(document).on('page:load', ready)
