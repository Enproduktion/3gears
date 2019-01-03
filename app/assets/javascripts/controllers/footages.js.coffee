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

# tab section handling

$tabs = null
$headerNavigation = null

handleTabClick = (e) ->

  e.preventDefault()

  $clicked = $(e.target)

  isValid = $clicked.prop('nodeName') == 'A' || $clicked.prop('nodeName') == 'LI'

  if isValid

    # handle tab

    isNestedLink = $clicked.prop('nodeName') == 'A'

    $tab     = if isNestedLink then $clicked.parent() else $clicked
    $tabLink = if isNestedLink then $clicked          else $tab.find('a').first()

    $tabs.removeClass('active-tab')
    $tab.addClass('active-tab')

    # handle content for tab

    tabName  = $tab.data('tab')

    $panes = $('.content-pane')
    $pane  = $(".#{tabName}-pane")

    $panes.removeClass('active-pane')
    $pane.addClass('active-pane')

setFootageReady = ->

  # handle attributes tabs navigation

  $tabs = $('.tab')

  $tabs.on 'click', handleTabClick

  # handle video player events

  $headerNavigation = $('.site-header__site-navigation')

  $videoElement = $('#video_annotation_container')

  if $videoElement.length > 0
    options =
      optionsAnnotator:
        permissions:
          showViewPermissionsCheckbox: false
          showEditPermissionsCheckbox: false
          user: '1'
        store:
          prefix: '/en/media/' + $videoElement.attr('media-id')
          annotationData: uri: 'annotationData'
          urls:
            create: '/medium_time_tags'
            update: '/medium_time_tags/:id'
            destroy: '/medium_time_tags/:id'
            search: '/medium_time_tags/'
        share: {}
        annotator: {}
      optionsRS: {}
      optionsOVA: posBigNew: 'none'
    ova = new OpenVideoAnnotation.Annotator($videoElement, options)

    videojs_id = $videoElement.find('.video-js').attr('id')
    player = ova.mplayer[videojs_id]

    player.captionsToggle()

#   load annotation id if given as param
    show_annotation_id = $videoElement.attr('initial-annotation-id')
    if show_annotation_id > 0
      ova.annotator.plugins['Store'].on 'annotationsLoaded', () =>
        ova.playTarget(show_annotation_id)


    if player.textTracks().length > 0
      #    add transcript
      options =
        showTitle: false
        showTrackSelector: false
      transcript = player.transcript(options)
      transcriptContainer = document.querySelector('#transcript_container');
      transcriptContainer.appendChild(transcript.el());
    else
      console.log('no track')


#  for player in $('.video-js')
#    videojs('example_video').ready () ->
#
#      # config button
#
#      addTagButton = this.controlBar.addChild 'button', {
#        test: 'Add Tag'
#      }
#
#      # fade out on play event 'timeupdate'
#
#      this.on 'timeupdate', ->
#        $headerNavigation.fadeOut() if $headerNavigation.css('display') != 'none'
#
#      this.on 'useractive', ->
#        $headerNavigation.fadeIn()

$(document).on('page:load ready', setFootageReady)
