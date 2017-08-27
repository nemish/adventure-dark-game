require 'main.constants'

gravity = -30
gravityV3 = vmath.vector3(0, gravity, 0)


function notify_player_obj_id(msg_name, obj_id)
    notify_player(msg_name, { obj_id = obj_id })
end


function notify_player(msg_name, data)
    msg.post(PLAYER_URL, msg_name, data)
end


function do_init(self)
    self.velocity = vmath.vector3(0, 0, 0)
    self.initial_z = go.get_position().z
    self.ground_contact = false
    self.ladder_contact = false
    self.land_contact = false
    self.slide_start = nil
    self.slide_start_direction_int = nil
    self.jump_start = false
    self.second_jump = false
    self.climbing = false
    self.ground_angle_y = 1
    self.ground_angle_x = 0
    self.actions = {}
    self.can_act = false
    self.elevator_id_standing_on = nil

    self.current_animation = nil -- the current animation
end


function play_animation(self, animation, sprite_name)
    if self.current_animation ~= animation then
        self.current_animation = animation
        msg.post(sprite_name or "#sprite", "play_animation", { id = animation })
    end
end


function handle_geometry_contact(self, normal, distance)
    local proj = vmath.dot(self.correction, normal)
    local comp = (distance - proj) * normal
    self.correction = self.correction + comp
    self.pos = self.pos + comp
    go.set_position(self.pos)

    self.ground_angle_y = normal.y
    self.ground_angle_x = normal.x
    if normal.y > 0.7 then
        self.ground_contact = true
        self.land_contact = true
    end
    proj = vmath.dot(self.velocity, normal)
    if proj < 0 then
        -- remove that component in that case
        self.velocity = self.velocity - proj * normal
        self.velocity.x = 0
    end
end


function updatePos(self, dt)
    self.pos.y = self.pos.y + self.velocity.y * dt
    y_offset = self.y_offset or 0
    if self.forced_pos_x then
        self.pos.x = self.pos.x + (self.forced_pos_x - self.pos.x) * dt * 10
    else
        self.pos.x = self.pos.x + self.velocity.x * dt
    end
    go.set_position(vmath.vector3(self.pos.x, self.pos.y + y_offset, self.initial_z))
end


function get_direction_from_touch(sender)
    return sender.fragment == hash("right_sense") and 1 or -1
end


function updateSpriteDirection(self)
    sprite.set_hflip("#sprite", self.direction == 1)
end
