module Layouts
  module FlashHelper
    def type_transform(type)
      type = type.to_sym
      FLASH_TYPES[type] || :primary
    end

    private

    FLASH_TYPES = {
      success: :success,
      error: :error,
      alert: :error
    }
  end
end
