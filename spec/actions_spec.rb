require "rspec"
p Dir["*"]
require_relative "../src/actions/actions"
require_relative "../src/model/state"


RSpec.describe Model::State do
  let(:initial_state) do
    Model::State.new(
      Model::Snake.new([
        Model::Coord.new(1,1),
        Model::Coord.new(0,1)
        ]),
      Model::Food.new(4, 4),
      Model::Grid.new(8, 12), 
      Model::Direction::DOWN,
      false
    )
  end

  let(:expected_state) do
    Model::State.new(
      Model::Snake.new([
        Model::Coord.new(2,1),
        Model::Coord.new(1,1)
      ]),
      Model::Food.new(4, 4),
      Model::Grid.new(8, 12), 
      Model::Direction::DOWN,
      false
    )
  end

  describe ".move_snake" do
    let(:actual_state) { described_class.move_snake(initial_state) }

    it "moves to expected state" do 
      expect(actual_state).to eq(expected_state)
    end
  end
end
