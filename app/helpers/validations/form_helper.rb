module Validations
  module FormHelper
    def validations_form_errors_for(resource, field)
      name = resource_attribute_name(resource, field)
      capture do
        concat(tag.div(nil, class: %i[mt-1]))
        concat(render(partial: "shared/form_feedback",
          collection: resource.errors[field],
          as: :feedback,
          locals: {css: %i[text-xs text-error-700],
                   icon: "ic:baseline-error",
                   emphasis: name}))
      end
    end

    def validations_form_suggestion(emphasis, text)
      capture do
        concat(render(partial: "shared/form_feedback",
          locals: {css: %i[text-xs text-secondary-700],
                   feedback: text,
                   icon: "ic:baseline-privacy-tip",
                   emphasis: emphasis}))
      end
    end
  end
end
