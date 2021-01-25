class View
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. #{recipe.done ? '[x]' : '[]'} - #{recipe.name.upcase} - Description: #{recipe.description} - Rating: #{recipe.rating} - prep-time: #{recipe.duration}"
    end
  end

  def ask_user_for_recipe
    puts "What do you want to cook?"
    return gets.chomp
  end

  def ask_user_for_description
    puts "what's the description of this recipe?"
    return gets.chomp
  end

  def ask_user_for_index
    return gets.chomp.to_i - 1
  end

  def search_query
    puts "What ingredient would you like a recipe for?"
    return gets.chomp
  end

  def rating
    puts "what's the rate you want to give to this recipe?"
    user_rate = gets.chomp.to_i
    return "#{user_rate}/5"
  end

  def mark_as_done
    puts "which recipe whould you like to mark as done? - put the index"
    return gets.chomp.to_i - 1
  end

  def ask_user_for_duration
    puts "how long the preparation of this recipe takes? specify hour and/or minutes"
    return gets.chomp
  end
end
