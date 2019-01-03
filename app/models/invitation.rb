# Copyright (C) 2017 Enproduktion GmbH
#
# This file is part of 3gears.
#
# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class Invitation < ActiveRecord::Base
  # Invite person to 3gears application
  # used in 'invite.rake'
  # 
  # Example:
  # Invitation.invite_person('email@example.com', 'en')
  # 
  def self.invite_person(email, locale)
    # create invitation token for user
    # 
    invitation = Invitation.create({
      token: SecureRandom.hex,
      email: email,
    })

    # send e-mail to invited user
    # 
    AccountMailer.invitation(email, locale, invitation).deliver_now
  end
end
