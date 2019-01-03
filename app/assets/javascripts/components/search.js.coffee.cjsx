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

searchTimeout = null

SearchSpinner = React.createClass
  render: ->
    active = @props.active
    if active
      <div>Ich suche...</div>
    else
      <div></div>
      
Search = React.createClass
  getInitialState: ->
    year_min = @props.year_min
    year_max = @props.year_max
    yearRangeValues = {min: year_min, max: year_max}

    for filter in @props.initial_filters
      if filter.type == 'year-range'
        [min, max] = filter.id.split('-')
        yearRangeValues = {min: Number(min), max: Number(max)}

    {
      selected_header: null
      quick_search_results: {collections: [], tags: [], organizations: []}
      query: @props.initial_query || ''
      filters: @props.initial_filters || []
      spinner_active: false
      collections: @props.collections || []
      tags: @props.tags || []
      yearRangeValues: yearRangeValues
      yearRangeMin: year_min
      yearRangeMax: year_max
    }

  doFullSearch: (query = null, filters = null) ->
    query   = if query == null then @state.query else query
    filters = if filters == null then @state.filters else filters
    filters = filters.map (filter) -> [filter.type, filter.id].join('_')
    window.location = "/#{I18n.currentLocale()}/search/footage?q=#{query}&filters=#{filters}"

  triggerSearch: (query) ->
    clearTimeout(searchTimeout)

    searchFunc = =>
      if query.length
        $.get "/#{I18n.currentLocale()}/quick-search",
              { q: query },
              (data) =>
                if query.length > 0
                  @setState quick_search_results: data
                else
                  @setState quick_search_results: @getInitialState().quick_search_results
              'json'
      else
        @setState quick_search_results: @getInitialState().quick_search_results

    searchTimeout = setTimeout(searchFunc, 200)

  handleFilterAdded: (newFilter) ->
    filters = @state.filters

    if newFilter.type == 'year-range'
      filters = filters.filter (filter) -> filter.type != 'year-range'

    filters = filters.concat(newFilter)
    query   = ''

    @setState filters: filters, query: query, selected_header: null, quick_search_results: @getInitialState().quick_search_results
    @doFullSearch(query, filters)

  handleFilterRemoved: (removedFilter) ->
    filters = @state.filters.filter (filter) -> [filter.type, filter.id].join('_') != [removedFilter.type, removedFilter.id].join('_')
    @setState filters: filters
    
    @doFullSearch(@state.query, filters)

  handleQueryChange: (query) ->
    @triggerSearch(query)
    @setState query: query

  handleReset: ->
    @setState query: '', filters: []
    @doFullSearch('', [])

  handleHeaderSelected: (selected_header) ->
    if selected_header != @state.selected_header
      @setState selected_header: selected_header
    else
      @setState selected_header: null

  onYearRangeChanges: (yearRangeValues) ->
    @setState yearRangeValues: yearRangeValues

  render: ->
    I18n.locale = @props.locale;

    selected_header      = @state.selected_header
    query                = @state.query
    quick_search_results = @state.quick_search_results
    filters              = @state.filters
    spinner_active       = @state.spinner_active
    collections          = @state.collections
    tags                 = @state.tags
    yearRangeValues      = @state.yearRangeValues
    yearRangeMin         = @state.yearRangeMin
    yearRangeMax         = @state.yearRangeMax

    <div>
      <div className="site-body__navigation__search__input">
        <SearchBar
          query={query}
          filters={filters}
          onFilterRemoved={@handleFilterRemoved}
          onChange={@handleQueryChange}
          onReset={@handleReset}
          onEnter={@doFullSearch}
        />
      </div>
      <div className="site-body__navigation__search__results">
        <SearchResults results={quick_search_results} onFilterClicked={@handleFilterAdded}/>
      </div>
      <div className="site-body__navigation__search__filters">
        <SearchFilters
          selected_header={selected_header}
          collections={collections}
          tags={tags}
          onFilterClicked={@handleFilterAdded}
          onHeaderSelected={@handleHeaderSelected}
          yearRangeValues={yearRangeValues}
          onYearRangeChanges={@onYearRangeChanges}
          yearRangeMin={yearRangeMin}
          yearRangeMax={yearRangeMax}
        />
      </div>
      <SearchSpinner active={spinner_active} />
    </div>
      
window.Search = Search
window.SearchSpinner = SearchSpinner
