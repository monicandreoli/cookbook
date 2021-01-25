class Recipe
  attr_accessor :name, :description, :rating, :done, :duration

  def initialize(name, description, rating, done = false, duration)
    @name = name
    @description = description
    @rating = rating
    @done = done
    @duration = duration
  end
end
