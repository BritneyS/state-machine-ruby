#Example:
class RiverCrossing < StateMachine
  state :start, initial: true
  state :chicken_on_farmer_side
  state :fox_on_farmer_side
  state :chicken_on_opposite_side
  state :grain_on_farmer_side
  state :fox_on_opposite_side
  state :chicken_on_farmer_side_again
  state :end

  event :move_chicken_to_farmer_side, transitions: {
    start: :chicken_on_farmer_side
  }

  event :move_fox_to_farmer_side, transitions: {
    chicken_on_farmer_side: :fox_on_farmer_side
  }

  event :move_chicken_back_to_opposite_side, transitions: {
    fox_on_farmer_side: :chicken_on_opposite_side
  }

  event :move_grain_to_farmer_side, transitions: {
    chicken_on_opposite_side: :grain_on_farmer_side
  }

  event :move_fox_to_opposite_side, transitions: {
    grain_on_farmer_side: :fox_on_opposite_side
  }

  event :move_chicken_to_farmer_side_again, transitions: {
    fox_on_opposite_side: :chicken_on_farmer_side_again
  }

  event :finish_crossing, transitions: {
    chicken_on_farmer_side_again: :end
  }
end

# Usage example
crossing = RiverCrossing.new

puts crossing.current_state  # Output: "start"

crossing.move_chicken_to_farmer_side
puts crossing.current_state  # Output: "chicken_on_farmer_side"

crossing.move_fox_to_farmer_side
puts crossing.current_state  # Output: "fox_on_farmer_side"

crossing.move_chicken_back_to_opposite_side
puts crossing.current_state  # Output: "chicken_on_opposite

#Should also include error handling and logging for state transitions