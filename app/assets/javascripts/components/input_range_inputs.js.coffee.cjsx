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

InputRangeInputs = React.createClass
  handleMinChange: (e) ->
    e.preventDefault()
    @props.onChange({min: e.target.value, max: this.props.value.max})

  handleMaxChange: (e) ->
    e.preventDefault()
    @props.onChange({min: this.props.value.min, max: e.target.value})

  render: ->
    <div className="input-range-inputs-container">
      <input type="text" className="input-range-inputs-min"  onChange={@handleMinChange} value={this.props.value.min} />
      <div className="input-range-inputs-separator">-</div>
      <input type="text" className="input-range-inputs-max" onChange={@handleMaxChange} value={this.props.value.max} />
    </div>

window.InputRangeInputs = InputRangeInputs
