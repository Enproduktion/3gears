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

module InputEditHelper
  include ActionView::Helpers::FormHelper

  def updateable_resource_tag(tag, record, options = {}, &block)
    raise ArgumentError, "Missing block" unless block_given?
    html_options = options[:html] ||= {}

    case record
    when String, Symbol
      object_name = record
      object      = nil
    else
      object      = record.is_a?(Array) ? record.last : record
      raise ArgumentError, "First argument in form cannot contain nil or be empty" unless object
      object_name = options[:as] || model_name_from_record_or_class(object).param_key
      apply_form_for_options!(record, object, options)
    end

    html_options[:data]   = options.delete(:data)   if options.has_key?(:data)
    html_options[:remote] = options.delete(:remote) if options.has_key?(:remote)
    html_options[:method] = options.delete(:method) if options.has_key?(:method)
    html_options[:authenticity_token] = options.delete(:authenticity_token)

    builder = instantiate_builder(object_name, object, options)
    output  = capture(builder, &block)
    html_options[:multipart] ||= builder.multipart?

    html_options = html_options_for_form(options[:url] || {}, html_options)
    custom_tag_with_body(tag, html_options, output)
  end

  private
  def custom_tag_with_body(tag, html_options, content)
    output = tag(tag, html_options, true)
    output << content
    output.safe_concat("</#{tag.to_s}>")
  end
end
