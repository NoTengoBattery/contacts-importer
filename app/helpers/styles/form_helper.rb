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
  end
end
