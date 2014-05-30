module Jekyll
  module CustomFilters
    def reduce_line_breaks(input)
      input.gsub /\n\s*\n/, "\n\s"
    end
  end
end

Liquid::Template.register_filter(Jekyll::CustomFilters)
