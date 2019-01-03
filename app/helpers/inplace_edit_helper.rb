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

module InplaceEditHelper
  class EditableResourceBuilder
    def initialize(helper, resource, enabled)
      @helper = helper
      @resource = (resource.class == Array) ? resource.last : resource
      @enabled = enabled
    end

    def string_field(field, attributes = nil, tag_name = "span")
      create_string_or_text_field(field, tag_name, "string", attributes)
    end

    def currency_field(field, unit, attributes = nil)
      attributes ||= {}
      blank = attributes.delete(:blank)

      format = { type: "currency", unit: unit, blank: blank }
      editable_field(field, "span", "string", format, attributes)
    end

    def text_field(field, attributes = nil, tag_name = "div")
      create_string_or_text_field(field, tag_name, "text", attributes)
    end

    def rich_text_field(field, attributes = nil)
      attributes ||= {}
      blank = attributes.delete(:blank)

      format = { type: "rich_text", blank: blank }
      editable_field(field, "div", "text", format, attributes)
    end

    def boolean_field(field, attributes = nil)
      attributes ||= {}
      true_text = attributes.delete(:true_text)
      false_text = attributes.delete(:false_text)

      format = { type: "boolean", true_text: true_text, false_text: false_text }
      editable_field(field, "span", "boolean", format, attributes)
    end

    def published_field(field, attributes = nil)
      format = { type: "published" }
      editable_field(field, "span", "boolean", format, attributes)
    end

    def finalize_field(field, attributes = nil)
      return unless @enabled

      attributes ||= {}
      redirect = attributes.delete(:redirect)
      attributes.merge!("data-inplace-redirect" => redirect)

      format = { type: "finalize" }
      editable_field(field, "span", "boolean", format, attributes)
    end

    def select_field(field, choices, attributes = nil)
      attributes ||= {}

      prompt = attributes.delete(:prompt)
      blank_option = attributes.delete(:blank_option)

      format = {
        type: @enabled ? "select" : "disabled_select",
        choices: choices,
        prompt: prompt,
        blank_option: blank_option,
      }

      # attributes.merge!( "class" => "form-control" ) if @enabled
      
      editable_field(field, @enabled ? "select" : "span", "select", format, attributes)
    end

    private

    def editable_field(field, tag_name, editor_type, format, attributes)
      attributes = (attributes || {}).with_indifferent_access

      value = @resource.send(field)
      selector = attributes.delete(:selector)

      if @enabled
        attributes.merge!(
          "class" => "editable-field #{attributes[:class]}".strip,
          "data-inplace-field" => "#{@resource.class.name.underscore}[#{field.to_s}]",
          "data-inplace-type" => editor_type,
          "data-inplace-value" => value.to_json,
          "data-inplace-selector" => selector,
        )
      else
        attributes.merge!(
          "class" => "field #{attributes[:class]}".strip,
        )
      end

      attributes[:class] = "blank #{attributes[:class]}".strip if value.blank?

      if ["input"].include?(tag_name)
        attributes.merge!(
          "class" => "form-control",
          "value" => value
        )
        content = ""
      elsif tag_name == "textarea"
        attributes.merge!("class" => "form-control")
        content = value
      else
        partial_path = "values/#{format[:type]}"
        case attributes[:template]
        when "3dox"
          partial_path = "values/3dox/#{format[:type]}"
        end
        content = @helper.render(partial: partial_path,
                                 locals: { value: value, format: format })
      end

      @helper.capture_haml do
        @helper.haml_tag(tag_name, content, attributes)
        # if @enabled && !['input', 'textarea', 'select'].include?(tag_name)
        #   @helper.haml_tag("div", "EDIT", {"data-edit-field" => "#{@resource.class.name.underscore}[#{field.to_s}]"})
        # end
      end
    end
    
    def create_string_or_text_field(field, tag_name, type, attributes)
      attributes ||= {}
      blank = attributes.delete(:blank)

      format = { type: type, blank: blank }
      editable_field(field, tag_name, type, format, attributes)
    end
  end

  # 
  # editable_resource_tag
  # tag_name = html element (:li, :div or dll)
  # resource = object
  # attributes = additional attributes like class or something else
  # 
  def editable_resource_tag(tag_name, resource, attributes = nil, &block)
    attributes = (attributes || {}).with_indifferent_access
    if resource.class.name == "Array"
      resource_path = attributes.delete(:resource_path) { polymorphic_url(resource) }
    else
      resource_path = attributes.delete(:resource_path) { url_for(resource) }
    end
    enabled = attributes.delete(:enabled) { true }

    if enabled
      attributes.merge!(
        "class" => "editable-resource #{attributes[:class]}".strip,
        "data-inplace-resource" => resource_path
      )
    else
      attributes.merge!(
        "class" => "resource #{attributes[:class]}".strip,
      )
    end

    builder = EditableResourceBuilder.new(self, resource, enabled)

    capture_haml do
      haml_tag(tag_name, capture_haml(builder, &block), attributes, true)
    end
  end

end
