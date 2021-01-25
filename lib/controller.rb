require_relative "view"
require_relative "cookbook"

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    display_recipes
  end

  def create
    name = @view.ask_user_for_recipe
    description = @view.ask_user_for_description
    rate = @view.rating
    duration = @view.ask_user_for_duration
    # 2. Create new task
    recipe = Recipe.new(name, description, rate, duration)
    # 3. Add to repo
    @cookbook.add_recipe(recipe)
  end

  def destroy
    # 1. Display list with indices
    display_recipes
    # 2. Ask user for index
    puts "select the index you what to delete!"
    index = @view.ask_user_for_index
    # 3. Remove from repository
    @cookbook.remove_recipe(index)
  end

  def import
    query = @view.search_query
    puts "Looking for #{query} recipes on the internet.."
    # printing the list of results from the browser
    results = @cookbook.search_in_browser(query)
    # this is where the scraping happnes
    puts "Which recipe would you like to import? - select the index"
    index_choice = @view.ask_user_for_index
    recipe = results[index_choice]
    new_recipe = Recipe.new(recipe[:name], recipe[:description], "#{recipe[:rating]}/5", recipe[:duration])
    @cookbook.add_recipe(new_recipe)
  end

  def mark
    list
    index_user_mark = @view.mark_as_done
    @cookbook.marking_as_done(index_user_mark)
    list
  end

  private

  def display_recipes
    # 1. Fetch tasks from repo
    recipes = @cookbook.all
    # 2. Send them to view for display
    @view.display(recipes)
  end
end
