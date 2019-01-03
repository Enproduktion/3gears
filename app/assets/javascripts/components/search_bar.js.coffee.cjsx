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

SearchBar = React.createClass
  handleKeyPress: (e) ->
    if e.key == 'Enter'
      console.log('show search results');
      @props.onEnter()

  handleFilterRemoved: (type, id, title) ->
    @props.onFilterRemoved({type: type, id: id, title: title})
        
  renderFilters: ->
    @props.filters.map (filter) =>
      <SearchFilter
        key={[filter.type, filter.id].join('_')}
        id={filter.id}
        type={filter.type}
        title={filter.title}
        onRemoveClicked={ @handleFilterRemoved }
      />

  handleReset: (e) ->
    e.preventDefault()
    @props.onReset()

  handleChange: (e) ->
    e.preventDefault()
    @props.onChange(e.target.value)
    
  renderReset: ->
    if @props.query.length > 0 || @props.filters.length > 0
      <a href="#" className="search__reset-link" onClick={@handleReset}><i className="search__reset-icon"></i></a>
        
  render: ->
    <div className="search-container">
      <div className="search-icon-container">
        <i aria-hidden="true" className="search-icon"></i>
      </div>
      <div className="search-filters-and-input">
        {@renderFilters()}
        <input
          placeholder={I18n.t('search.search_bar.placeholder')}
          type="text"
          name="q"
          className="search-input"
          onChange={@handleChange}
          onKeyPress={@handleKeyPress}  
          autoComplete="off"
          value={@props.query}
        />
      </div>
      <div className="search-reset-icon">
        {@renderReset()}
      </div>
    </div>

window.SearchBar = SearchBar
