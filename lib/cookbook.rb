require_relative "recipe"
require "csv"
require "nokogiri"
require "open-uri"
require "pry-byebug"

class Cookbook
  attr_accessor :recipes

  def initialize(csv_file)
    @recipes = []
    @csv_file = csv_file
    @csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    parsing_recepies
  end

  def parsing_recepies
    # PARSING
    CSV.foreach(@csv_file, @csv_options) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3] == "true", row[4])
    end
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    storing_recipes
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    storing_recipes
  end

  def search_in_browser(query)
    # it takes query as an argument
    # SCRAPING
     html_string = open("https://www.marmiton.org/recettes/recherche.aspx?aqt=#{query}").read
     nokogiri_doc = Nokogiri::HTML(html_string)
    # scraping title
     search_results = []
     nokogiri_doc.search('.recipe-card').each do |element|
       title = element.search('.recipe-card__title').text.strip.upcase
       description = element.search('.recipe-card__description').text.strip
       rating = element.search('.recipe-card__rating__value').text.strip
       # binding.pry
       duration = element.search(".recipe-card__duration__value").text.strip
       # from the allrecipes website
       # rating = element.search(".stars").attribute("data-ratingstars").value.to_f.round(1)
       # title = element.search(".fixed-recipe-card__h3").text.strip
       # description = element.search(".fixed-recipe-card__description").text.strip
       search_results << { name: title, description: description, rating: rating, duration: duration }
     end

     puts "Here are the results for #{query}:"
     search_results.take(5).each_with_index do |item, index|
       puts "#{index + 1}. - #{item[:name]} - #{item[:description]} - #{item[:rating]} - #{item[:duration]}"
     end
   end

  def marking_as_done(marked_item)
    @recipes.each_with_index do |recipe, index|
      if index == marked_item
        recipe.done = true
      end
    end
    storing_recipes
  end

  def storing_recipes
    # STORING
    CSV.open(@csv_file, 'wb', @csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.done, recipe.duration]
      end
    end
  end
end


