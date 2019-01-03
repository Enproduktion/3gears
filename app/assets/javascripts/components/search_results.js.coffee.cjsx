{###
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
###}

SearchResults = React.createClass
  handleFilterClicked: (e, type, id, title) ->
    type = 'tags' if type == 'tag'
    @props.onFilterClicked({type: type, id: id, title: title})
    e.preventDefault()

  renderQuickResult: (type, quick_result, isFilter) ->
    if isFilter
      <a
        key={[quick_result.type, quick_result.id].join('_')}
        className="search__quick-result__item"
        href="#"
        onClick={ (e)=> @handleFilterClicked(e, type, quick_result.id, quick_result.title)}
      >
        {quick_result.title}
      </a>
    else
      <a
        key={[quick_result.type, quick_result.id].join('_')}
        className="search__quick-result__item"
        href={ quick_result.url }
      >
        {quick_result.title}
      </a>

  renderQuickResults: (type, title, list, isFilter) ->
    return if !list || list.length == 0
    quick_results = list.map (quick_result) =>
      @renderQuickResult(type, quick_result, isFilter)

    <div className="search__quick-result-wrapper">
      <div className="search__quick-result__title">{title}</div>
      <div className="search__quick-result__list">
        {quick_results}
      </div>
    </div>

  hasResults: ->
    @props.results.collections.length > 0 || @props.results.tags.length > 0 || @props.results.organizations.length > 0
      
  render: ->
    <div className={['search__quick-result__body', if @hasResults() then 'is-active' else ''].join(' ')}>
      { @renderQuickResults('tag', 'Themen', @props.results.tags, true) }
      { @renderQuickResults('collection', 'Kollektionen', @props.results.collections, false) }
      { @renderQuickResults('organization', 'Organisationen', @props.results.organizations, false) }
    </div>

window.SearchResults = SearchResults
