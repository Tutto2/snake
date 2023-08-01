require_relative "view/ruby2d"
require_relative "model/state"
require_relative "actions/actions"
require "pry"

class App 
  def initialize
      @state = Model::initial_state
  end

  def start
      @view = View::Ruby2dView.new(self)
      timer = Thread.new { init_timer(@view) }
      @view.start(@state)
      timer.join
  end

  def init_timer(view)
      loop do
        if @state.game_over == true
          puts "Game Over"
          puts "Puntaje: #{@state.snake.positions.length}"
          break
        end
        #puts "State: #{@state.game_over.inspect}"
        @state = Actions::move_snake(@state)
        view.render(@state)
        x = @state.snake.positions.length
        sleep (x * 2.0) / ((x ** 2.0) + 1.0)
        # sleep (x ** 2).to_f / ((x ** 3) +1)
      end    
  end

  def send_action (action, params)
    new_state = Actions.send(action, @state, params)
    #binding.pry
    if new_state.hash != @state
      @state = new_state
      @view.render(@state)
    end
  end
end

app = App.new
app.start