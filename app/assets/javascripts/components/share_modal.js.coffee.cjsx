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

ShareModal = React.createClass
  getInitialState: ->
    {
      linkURL: window.location.href
      email: ''
    }

  componentDidMount: ->
    $('.share-button').on 'click', (e) =>
      e.preventDefault()
      @openModal()

    $('.share-close-button').on 'click', (e) =>
      e.preventDefault()
      @closeModal()

  setEmail: (e) ->
    email = event.target.value
    @setState
      email: email

  openModal: ->
    $('.share-modal').fadeIn (e) ->
      $('.share-modal__window').slideDown()

  closeModal: ->
    $('.share-modal__window').slideUp (e) ->
      $('.share-modal').fadeOut()

  handleOverlayClick: (e) ->
    @closeModal() if e.target.className == 'share-modal'

  render: ->
    socialMessage = encodeURI "#{document.title}\n#{@state.linkURL}"

    <div className="share-modal" onClick={@handleOverlayClick}>
      <div className="share-modal__window">
        <header className="share-modal__window__header">
          <i className="share-button__icon" aria-hidden="true"/>
          <a href="#" className="share-close-button">
            <i className="close-icon" aria-hidden="true"/>
          </a>
        </header>
        <div className="share-modal__window__body">
          <h3>Link</h3>
          <a href={@state.linkURL}>{@state.linkURL}</a>
          <h3>Social</h3>
          <ul>
            <li>
              <a target="_blank" href="https://www.facebook.com/sharer/sharer.php?u=#{@state.linkURL}">
                <i className="facebook-icon" aria-hidden="true"></i>
              </a>
            </li>
            <li>
              <a target="_blank" href="https://twitter.com/home?status=#{socialMessage}">
                <i className="twitter-icon" aria-hidden="true"></i>
              </a>
            </li>
          </ul>
          <h3>Email</h3>
          <input
            placeholder="E-Mail Adresse"
            type="email"
            className="share-email-input"
            onChange={@setEmail}
          />
          <a
            className="share-email"
            href="mailto:#{@state.email}?subject=audio%20visuelles%20archiv&body=#{socialMessage}">
              Vorschau
          </a>
        </div>
      </div>
    </div>

window.ShareModal = ShareModal
