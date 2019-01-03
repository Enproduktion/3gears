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

registerPaneToggle = ($pane, triggers) ->
  ($toggleTrigger.on 'click', (e) =>
    e.preventDefault()
    $pane.toggle()
  ) for $toggleTrigger in triggers

registerApplicationEvents = ->
  registerPaneToggle $('.site-navigation__user-pane'), [
    $('.user-avatar')
    $('.user-pane__background')
    $('.user-pane__close-button')
  ]
  registerPaneToggle $('.site-navigation__pages-pane'), [
    $('.site-header__site-navigation__main__menu-button')
    $('.pages-pane__background')
    $('.pages-pane__close-button')
  ]
  registerPaneToggle $('.site-navigation__login-pane'), [
    $('.login-button')
    $('.login-pane__background')
    $('.login-pane__close-button')
  ]

$(document).on 'ready', registerApplicationEvents
$(document).on 'page:load', registerApplicationEvents
