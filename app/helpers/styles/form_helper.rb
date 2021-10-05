module Styles
  module FormHelper
    def style_form_label
      classes = %i[inline-block]
      classes += %i[text-base text-display-800]
      classes
    end

    def style_form_field
      classes = %i[appearance-none block]
      classes += %i[border-b-2 border-opacity-50 border-primary-500 outline-none]
      classes += %i[focus:border-opacity-0 focus:ring-2 focus:ring-opacity-75 focus:ring-primary-700 focus:rounded]
      classes += %i[px-2 py-1 w-full]
      classes += %i[text-base text-primary-800]
      classes
    end

    def style_form_file_field
      classes = style_form_field
      classes -= %i[px-2 py-1]
      classes -= %i[focus:border-opacity-0]
      classes += %i[focus:border-0]
      classes
    end

    def style_form_button() = %i[bg-primary-700 float-right mx-1 px-3 py-1.5 text-white]

    def style_form_link
      classes = %i[flex items-center justify-center]
      classes += %i[bg-primary-100 h-8 rounded-md w-8]
      classes += %i[no-underline text-display-500 hover:text-display-600]
      classes
    end
  end
end
