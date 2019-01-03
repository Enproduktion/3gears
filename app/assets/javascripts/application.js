// Copyright (C) 2017 Enproduktion GmbH
//
// This file is part of 3gears.
//
// 3gears is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.




// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery-ui/autocomplete
//= require react
//= require components
//= require react_ujs
//= require i18n.js
//= require i18n/translations
//= require tag-it
//= require featherlight
//= require fotorama
//= require react-input-range
//= require video
//= require_tree ./videojs
//= require videojs-caption-toggle
//= require ./lib/animation
//= require ./lib/error
//= require ./lib/flash
//= require ./lib/upload
//= require ./lib/medium_status_display
//= require ./lib/xhr_status
//= require ./lib/inplace_edit
//= require ./lib/tag_editor
//= require ./lib/carousel
//= require ./lib/file_upload
//= require ./lib/show_create
//= require ./lib/video_player
//= require ./lib/ujs
//= require ./lib/user_suggest
//= require_tree ./controllers

window.findReactDOMNodes = function($root) {
  return $root.find('[data-react-class]');
};

window.mountReactComponents = function($root) {
  var nodes = findReactDOMNodes($root);
  for (var i = 0; i < nodes.length; ++i) {
    var node = nodes[i];
    var className = node.getAttribute('data-react-class');

    var constructor = window[className] || eval.call(window, className);
    var propsJson = node.getAttribute('data-react-props');
    var props = propsJson && JSON.parse(propsJson);
    React.render(React.createElement(constructor, props), node);
  }
}
