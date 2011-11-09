class MainController < ApplicationController

  def initial
    Individual.delete_all
    World.delete_all
    
    world = World.new
    
    world.red = 32
    world.green = 64
    world.blue = 128
    world.num_losers = 8
    world.mutation_frequency = 0.025
    world.mutation_size = 25
    world.save
    
    400.times do
      new_ind = Individual.new
      new_ind.red = rand(255)
      new_ind.green = rand(255)
      new_ind.blue = rand(255)
      new_ind.score = Math.sqrt((world.red - new_ind.red)**2 + (world.green - new_ind.green)**2 + (world.blue - new_ind.blue)**2)
      new_ind.alive = 1
      new_ind.save
    end
    
    redirect_to "/main/draw"
  end
  
  def modify
    @gen = Individual.all
    @world = World.first
  end
  
  def update
    gen = Individual.all
    target = World.first
    
    form_data = params[:world]
    target.red = [[form_data[:red].to_i, 0].max, 255].min
    target.green = [[form_data[:green].to_i, 0].max, 255].min
    target.blue = [[form_data[:blue].to_i, 0].max, 255].min
    target.num_losers = [[form_data[:num_losers].to_i, 0].max, 400].min
    target.mutation_frequency = [[form_data[:mutation_frequency].to_f, 0].max, 1].min
    target.mutation_size = [[form_data[:mutation_size].to_i, 0].max, 255].min
    target.save
    
    400.times do |i|
      gen[i].score = Math.sqrt((target.red - gen[i].red)**2 + (target.green - gen[i].green)**2 + (target.blue - gen[i].blue)**2)
      gen[i].save
    end
    
    redirect_to "/main/draw"
  end

  def draw
    @gen = Individual.all
    @world = World.first

    sorted_gen = Individual.all.sort { |a,b| a.score <=> b.score }
    
    num_losers = @world.num_losers.to_i
    num_losers.times do |i|
      sorted_gen[(400 - num_losers) + i].red = sorted_gen[i].red
      sorted_gen[(400 - num_losers) + i].green = sorted_gen[i].green
      sorted_gen[(400 - num_losers) + i].blue = sorted_gen[i].blue
      sorted_gen[(400 - num_losers) + i].score = sorted_gen[i].score
      sorted_gen[(400 - num_losers) + i].save
    end

    mutation_frequency = @world.mutation_frequency
    mutation_size = @world.mutation_size
    400.times do |i|
      if rand < mutation_frequency then
        @gen[i].red = [[@gen[i].red + rand(mutation_size*2) - mutation_size, 0].max, 255].min
        @gen[i].green = [[@gen[i].green + rand(mutation_size*2) - mutation_size, 0].max, 255].min
        @gen[i].blue = [[@gen[i].blue + rand(mutation_size*2) - mutation_size, 0].max, 255].min
        @gen[i].score = Math.sqrt((@world.red - @gen[i].red)**2 + (@world.green - @gen[i].green)**2 + (@world.blue - @gen[i].blue)**2)
        @gen[i].save
      end
    end

  end
end
