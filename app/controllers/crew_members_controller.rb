# Copyright (C) 2017 Enproduktion GmbH
# This file is part of 3gears.

# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class CrewMembersController < ApplicationController
  include HasPolymorphicParent
  before_filter { @work = find_polymorphic_parent }
  authorize_resource :work
  authorize_resource :crew_member, through: :work, only: [:create]
  load_and_authorize_resource :crew_member, through: :work, except: [:create]

  theme Frontend::APP_STYLE unless Frontend.is_empty_style?

  # Create crew member, or add occupations if crew member already exists
  def create
    who = params[:who]
    user = User.find_by_username(who)
    occupation_names = params[:crew_member][:occupations]

    if not user
      # Email invites do not work at the moment, so we do not allow them.
      render_errors("User not found", :unprocessable_entity)
      return
    end

    @crew_member = CrewMember.find_or_create_by!(user: user, work: @work)
    occupation_names += @crew_member.occupations.map &:occupation

    @crew_member.update_occupations(occupation_names)
    @crew_member.save!

    # TODO: When should we send notifications?
    # @crew_member.send_notification(params[:message]) if @crew_member.user != current_user

    if params[:render_whole_crew]
      render partial: "crew_members/crew_member_list", locals: { editable: true, work: @work }
    else
      render @crew_member, locals: { editable: true, work: @work }
    end
  end

  def update
    occupation_names = params[:crew_member][:occupations]

    @crew_member.update_occupations(occupation_names)
    @crew_member.save!

    render @crew_member, locals: { editable: true, work: @work }
  end

  def destroy
    @crew_member.destroy
    head :ok
  end

  private
  def create_params
    params.require(:crew_member).permit(occupations_attributes: [:id, :occupation, :_destroy]) if params[:crew_member]
  end
  alias_method :update_params, :create_params
end
