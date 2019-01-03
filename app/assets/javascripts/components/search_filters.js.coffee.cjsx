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

SearchFilters = React.createClass
  handleFilterClicked: (e, type, id, title) ->
    @props.onFilterClicked({type: type, id: id, title: title})

  itemName: (item) ->
    item.title || item.name

  groupByFirstChar: (list) ->
    grouped = {}
    for item in list
      name = @itemName(item)
      if name && name.length > 0
        key  = name.charAt(0)
        grouped[key] ?= []
        grouped[key].push item
    grouped

  renderList: (type, list) ->
    list.map (filter) =>
      title = filter.title || filter.name
      
      <div key={[type, filter.id].join('_')} className="search__filter__selectable" onClick={ (e)=> @handleFilterClicked(e, type, filter.id, title)}>{title}</div>
    

  renderFilterList: ->
    type = @props.selected_header
    return unless type
    if type == 'years'
      return <SearchRangeSelector min={@props.yearRangeMin} max={@props.yearRangeMax} values={@props.yearRangeValues} onChange={@props.onYearRangeChanges} onSetYearRangeAsFilter={@props.onFilterClicked}/> 
      
    groups = @groupByFirstChar(@props[type])
    
    Object.keys(groups).sort().map (key) =>
      <div className="search__filter__group" key={key}>
        <div className="search__filter__group-key">{key}</div>
        <div className="search__filter__group-list">
          {@renderList(type, groups[key])}
        </div>
      </div>

  selectHeader: (e, selected_header) ->
    e.preventDefault()
    @props.onHeaderSelected(selected_header)
        
  renderHeader: (name, title) ->
    <div className="search__filter__header-wrapper">
    <a
      href="#"
      className={['search__filter__header', if @props.selected_header == name then 'is-active' else ''].join(' ')}
      onClick={ (e) => @selectHeader(e, name) }
    >
      {title}
    </a>
    {@renderArrow(name)}
    </div>

  renderArrow: (name)->
    if @props.selected_header == name
      <div className="search__arrow-box"></div>

  render: ->
    <div>
      <div className="search__filter__header__row">
        {@renderHeader('collections', I18n.t('search.collections'))}
        {@renderHeader('tags', I18n.t('search.topics'))}
        {@renderHeader('years', I18n.t('search.years'))}
      </div>
      <div className="search__filter__body">
        <div className="search__filter__body__inner-wrapper">
          {@renderFilterList()}
        </div>
      </div>
    </div>

window.SearchFilters = SearchFilters

