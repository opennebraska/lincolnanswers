module Jekyll

  class CategoryPage < Page
    def initialize(site, base, dir, category, child_pages)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['child_pages'] = child_pages

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class CategoryListing < Page
    def initialize(site, base, categories)
      @site = site
      @base = base
      @dir = ''
      @name = 'categories.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_listing.html')
      self.data['categories'] = categories.map {|cat| cat.split.map(&:capitalize).join(' ')}
      self.data['title'] = "Categories"
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    include Filters

    def generate(site)
      if site.layouts.key? 'category_index'
        dir = 'categories'
        answers_sorted = {}
        site.collections['answers'].docs.each do |answer|
          unless answers_sorted[answer.data['category'].downcase]
            answers_sorted[answer.data['category'].downcase] = []
          end
          answers_sorted[answer.data['category'].downcase] << answer
        end
        answers_sorted.each_pair do |category, answer_list|
          site.pages << CategoryPage.new(site, site.source, File.join(dir, cgi_escape(category)), answer_list.first.data['category'], answer_list)
        end
        site.pages << CategoryListing.new(site, site.source, answers_sorted.keys.sort)
      end
    end
  end

end
