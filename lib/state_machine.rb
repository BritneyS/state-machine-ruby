# This class is a framework for setting states and transitions. 
# Originally created for the purpose of defining valid state 
# changes when applying asynchronous events.
class StateMachine
  # Defines the `state` class method of the StateMachine class.
  #
  # @param name [Symbol] The name of the state.
  # @param options [Hash] Valid options: 
  #   - :initial_state [Boolean] - Sets the instance variable `@state`` to `true`.
  def self.state(name, options = {})
    state_name = name.to_s
    state_variable = "@#{state_name}"

    # Enables the ability to call methods like `state=`, `state?`, and `state!`,
    # depending on the `state_name`.
    define_method(state_name) { instance_variable_get(state_variable) }
    define_method("#{state_name}?") { instance_variable_get(state_variable) == true }
    define_method("#{state_name}!") { instance_variable_set(state_variable, true) }

    # Instance variable `@state` set to `false` by default, unless `:initial_state`
    # option is passed as `true`.
    if options[:initial_state]
      define_method(:initialize) { instance_variable_set(state_variable, true) }
    else
      define_method(:initialize) { instance_variable_set(state_variable, false) }
    end
  end

  def self.event(name, options = {})
    event_name = name.to_s

    define_method(name) do
      return if !send(options[:if]) if options[:if]
      return if send(options[:unless]) if options[:unless]

      send("#{event_name}!")
    end

    define_method("#{event_name}!") do
      transitions = options[:transitions]
      return unless transitions && transitions.include?(current_state)

      send("#{current_state}=", false)
      send("#{transitions[current_state]}=", true)
    end
  end

  def current_state
    instance_variables.each do |variable|
      return variable.to_s.gsub("@", "") if instance_variable_get(variable) == true
    end
    nil
  end
end