module Styles
  module TableHelper
    def style_table() = %i[border-primary-900 text-primary-700 w-full]

    def style_table_head() = %i[border-b-2 border-solid]

    def style_table_cell(pad) = %i[border min-w-32 text-center].+([:"px-#{pad}"])
  end
end
