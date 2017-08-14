

function calc_action_time(self)
    state_config = self.STATES_CONFIG[self.state]
    if state_config.always then
        return nil
    elseif state_config.random then
        return math.random(state_config[1], state_config[1] + state_config[1] / 2)
    end
    return state_config[1]
end