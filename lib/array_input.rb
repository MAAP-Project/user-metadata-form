class ArrayInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_html_options[:type] ||= input_type

    array_elements = object.public_send(attribute_name)
    if array_elements.length == 0
      array_elements = ["", "", ""]
    end
    Array(array_elements).map do |array_el|
      @builder.text_field(nil, input_html_options.merge(
        value: array_el,
        name: "#{object_name}[#{attribute_name}][]",
        style: 'margin-right: 5px;'
      ))
    end.join.html_safe
  end

  def input_type
    :text
  end
end
