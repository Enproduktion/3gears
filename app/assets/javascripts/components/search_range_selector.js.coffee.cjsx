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

SearchRangeSelector = React.createClass
  onChange: (values) ->
    @props.onChange values

  onSetClicked: (e) ->
    e.preventDefault()

    id = "#{@props.values.min}-#{@props.values.max}"
    
    @props.onSetYearRangeAsFilter {id: id, type: 'year-range', title: id}

  renderEmptyState: ->
    <div className="search-range-selector">
      {I18n.t('search.search_range_selector.empty_state_message')}
    </div>

  render: ->
    values = @props.values
    min    = @props.min
    max    = @props.max

    return @renderEmptyState() if min == 0 || min == max

    <div className="search-range-selector">
      <div className="search-range-slider">
        <InputRange maxValue={max} minValue={min} onChange={ @onChange } value={ values } />
      </div>
      <div className="search-range-inputs">
        <InputRangeInputs maxValue={max} minValue={min} onChange={ @onChange } value={ values } />
      </div>
      <div className="set-search-button-wrapper">
        <a className="set-search-range-btn" href="#" onClick={@onSetClicked}>{I18n.t('search.search_range_selector.set_as_filter')}</a>
      </div>
    </div>

window.SearchRangeSelector = SearchRangeSelector
