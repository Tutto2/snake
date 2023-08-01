module Model
  module Direction
    UP = :up 
    DOWN = :down
    RIGHT = :right
    LEFT = :left
  end

  class Coord < Struct.new(:row, :col)
    def to_a
      [self.row, self.col]
    end
  end

  class Food_one < Coord
  end
  
  class Food_two < Coord
  end

  class Food_three < Coord
  end

  class Snake < Struct.new(:positions)
  end

  class Grid < Struct.new(:rows, :cols)
  end

  class Wall
    attr_accessor :bricks, :a, :b
    
    def initialize(a, b)
      ax, ay = a
      bx, by = b
      if ax == bx 
        @bricks = (ay..by).map { |y| [ax, y]}
      elsif ay == by
        @bricks = (ax..bx).map { |x| [x, ay]}
      else
        @bricks = []
      end
    end 
  end

  class State < Struct.new(:walls, :snake, :food_one, :food_two, :food_three, :grid, :curr_direction, :game_over)
    def self.move_snake(state)
      false
    end
    
    def move_snake(direction)
      self.curr_direction = direction
    end
  end

  def self.initial_state
    State.new(
      [
        Wall.new([0, 0], [29, 0]), 
        Wall.new([0, 0], [0, 7]),
        Wall.new([0, 14], [0, 20]),
        Wall.new([0, 20], [29, 20]),
        Wall.new([29, 0], [29, 7]),
        Wall.new([29, 14], [29, 20])
      ],
      Snake.new([
        Coord.new(1,1),
        Coord.new(0,1)
      ]),
      Food_one.new(rand(1..19), rand(1..28)),
      Food_two.new(rand(1..19), rand(1..28)),
      Food_three.new(rand(1..19), rand(1..28)),
      Grid.new(21, 30), 
      Direction::DOWN,
      false
    )
  end
end

# Generar una sola pared que sea solida
# Walls.new([0, 0], [0, 30])