require "ruby2d"
require_relative "../model/state"

module View
  class Ruby2dView
    include Ruby2D::DSL
    
    def initialize(app)
      @pixel_size = 20
      @app = app
    end

    def start(state)
      #extend Ruby2D::DSL
      set(title: "Snake", 
          width: @pixel_size * state.grid.cols,
          height: @pixel_size * state.grid.rows)
      on :key_down do |event|
        handle_key_event(event)        
      end
      show
    end

    def render(state)
      #extend Ruby2D::DSL
      close if state.game_over == true
      render_food_one(state.food_one)
      render_food_two(state.food_two)
      render_food_three(state.food_three)
      render_snake(state.snake)
      render_walls(state.walls)
    end

    private
    def render_walls(walls)
      #extend Ruby2D::DSL
      walls.each do |wall|
        wall.bricks.each do |(ax, ay)|
          Square.new(
            x: ax * @pixel_size,
            y: ay * @pixel_size,
            size: @pixel_size,
            color: 'teal'
          )
        end
      end
    end

    def render_food_one(food_one)
      #extend Ruby2D::DSL
      @food_one.remove if @food_three
      @food_one = Square.new(
        y: food_one.row * @pixel_size,
        x: food_one.col * @pixel_size,
        size: @pixel_size,
        color: 'lime'
      )
    end

    def render_food_two(food_two)
      #extend Ruby2D::DSL
      @food_two.remove if @food_two
      @food_two = Square.new(
        y: food_two.row * @pixel_size,
        x: food_two.col * @pixel_size,
        size: @pixel_size,
        color: 'blue'
      )
    end

    def render_food_three(food_three)
      #extend Ruby2D::DSL
      @food_three.remove if @food_three
      @food_three = Square.new(
        y: food_three.row * @pixel_size,
        x: food_three.col * @pixel_size,
        size: @pixel_size,
        color: 'fuchsia'
      )
    end

    def render_snake(snake)
      #extend Ruby2D::DSL
      @snake_positions.each(&:remove) if @snake_positions
      @snake_positions = snake.positions.map do |pos|
        Square.new(
          x: pos.col * @pixel_size,
          y: pos.row * @pixel_size,
          size: @pixel_size,
          color: 'white'
        )
      end
    end

    def handle_key_event(event)
      case event.key
      when "down"
        @app.send_action(:change_direction, Model::Direction::DOWN)
      when "up"
        @app.send_action(:change_direction, Model::Direction::UP)
      when "left"
        @app.send_action(:change_direction, Model::Direction::LEFT)
      when "right"
        @app.send_action(:change_direction, Model::Direction::RIGHT)
      end
    end
  end
end
