require_relative "../model/state"

module Actions
  def self.move_snake(state)
    next_direction = state.curr_direction
    next_position = calc_next_position(state)
    # Verificar siguiente casilla
    if position_is_food_one?(state, next_position)
      state = grow_snake(state, next_position)
      generate_food_one(state)

    elsif position_is_food_two?(state, next_position)
      state = grow_snake(state, next_position)
      generate_food_two(state)

    elsif position_is_food_three?(state, next_position)
      state = super_grow_snake(state, next_position)
      generate_food_three(state)

    elsif position_is_out?(state, next_position)
      tele_position = teleport(state, next_position)
      new_position = tele_position + state.snake.positions[0...-1]
      state.snake.positions = new_position
      state
      
    elsif position_is_valid?(state, next_position)
      move_snake_to(state, next_position)
    else
      state = end_game(state)
    end
    state
  end

  def self.change_direction(state, direction)
    if next_direction_is_valid?(state, direction)
      state.curr_direction = direction
    else
      puts "Invalid move"
    end
    state
  end

  def self.position_is_out?(state, next_position)
    is_out = ((next_position.row >= state.grid.rows ||
    next_position.row < 0) ||
    (next_position.col >= state.grid.cols ||
    next_position.col < 0))
    return true if is_out
  end

  def self.teleport(state, next_position)
    curr_position = state.snake.positions.first
    case
    #Pared de la derecha
    when (next_position.col >= state.grid.cols)
      return [Model::Coord.new(
        curr_position.row, 
        curr_position.col - 29
        )]
    #Pared de la izquierda
    when (next_position.col < 0)
      return [Model::Coord.new(
        curr_position.row, 
        curr_position.col + 29
        )]
    #Pared de abajo
    when (next_position.row >= state.grid.rows)
      return [Model::Coord.new(
        curr_position.row - 20, 
        curr_position.col
        )]
    #Pared de arriba
    when (next_position.row < 0)
      return [Model::Coord.new(
        curr_position.row + 20, 
        curr_position.col
        )]
    end
  end

  def self.generate_food_one(state)
    new_food_one = Model::Food_one.new(rand(1..19), rand(1..28))
    state.food_one = new_food_one
    state
  end

  def self.generate_food_two(state)
    new_food_two = Model::Food_two.new(rand(1..19), rand(1..28))
    state.food_two = new_food_two
    state
  end

  def self.generate_food_three(state)
    new_food_three = Model::Food_three.new(rand(1..19), rand(1..28))
    state.food_three = new_food_three
    state
  end

  def self.position_is_food_one?(state, next_position)
    (state.food_one.row == next_position.row && state.food_one.col == next_position.col)
  end

  def self.position_is_food_two?(state, next_position)
    (state.food_two.row == next_position.row && state.food_two.col == next_position.col)
  end

  def self.position_is_food_three?(state, next_position)
    (state.food_three.row == next_position.row && state.food_three.col == next_position.col)
  end

  def self.grow_snake(state, next_position)
    new_snake = [next_position] + state.snake.positions
    state.snake.positions = new_snake
    state
  end

  def self.super_grow_snake(state, next_position)
    new_snake = [next_position] + state.snake.positions
    state.snake.positions = new_snake
    state
    new_snake = [next_position] + state.snake.positions
    state.snake.positions = new_snake
    state
  end

  def self.calc_next_position(state)
    curr_position = state.snake.positions.first
    case state.curr_direction
    when Model::Direction::UP 
      return Model::Coord.new(
        curr_position.row - 1, 
        curr_position.col
        )
    when Model::Direction::DOWN 
      return Model::Coord.new(
        curr_position.row + 1, 
        curr_position.col
        )
    when Model::Direction::RIGHT
      return Model::Coord.new(
        curr_position.row, 
        curr_position.col + 1
        )
    when Model::Direction::LEFT
      return Model::Coord.new(
        curr_position.row, 
        curr_position.col - 1
        )
    end
  end
  
  def self.position_is_valid?(state, position)
    snake_is_touched = state.snake.positions.include? position
    wall_is_touched = state.walls.any? do |wall|
      # Reverse porque las posiciones de los ladrillos son 
      # invertidas a las posiciones de las coordenadas
      wall.bricks.include? position.to_a.reverse
    end
    bricks = state.walls.map(&:bricks)
    #puts "Position #{position.to_a.inspect}"
    #puts "Bricks #{bricks.inspect}"
    #puts "Snake: #{snake_is_touched}, Wall: #{wall_is_touched}"
    !(snake_is_touched || wall_is_touched)
  end

  def self.move_snake_to (state, next_position)
    new_position = [next_position] + state.snake.positions[0...-1]
    state.snake.positions = new_position
    state
  end

  def self.end_game(state)
    state.game_over = true
    state
  end

  def self.change_direction(state, direction)
    case direction
    when Model::Direction::UP
      state.move_snake(Model::Direction::UP) if state.curr_direction != Model::Direction::DOWN
    when Model::Direction::DOWN
      state.move_snake(Model::Direction::DOWN) if state.curr_direction != Model::Direction::UP
    when Model::Direction::LEFT
      state.move_snake(Model::Direction::LEFT) if state.curr_direction != Model::Direction::RIGHT
    when Model::Direction::RIGHT
      state.move_snake(Model::Direction::RIGHT) if state.curr_direction != Model::Direction::LEFT    
    end
    return state
  end
end