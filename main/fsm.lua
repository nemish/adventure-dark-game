require 'main.constants'

function calc_action_time(self)
    state_config = self.STATES_CONFIG[self.state]
    if state_config.always then
        return nil
    elseif state_config.random then
        return math.random(state_config[1], state_config[1] + state_config[1] / 2)
    end
    return state_config[1]
end


function set_state(self, state)
    self.t = 0
    self.state = state
end


function check_state(self, state)
    return self.state == state
end


function on_enemy_obstacle_reached(self)
    set_state(self, IDLE)
    self.direction = -self.direction
    updateSpriteDirection(self)
end

