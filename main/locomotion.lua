gravity = -20
gravityV3 = vmath.vector3(0, gravity, 0)
CONSTRUCTION_GROUP = hash("construction")
ELEVATOR_GROUP = hash("elevator")
GROUND_GROUP = hash("ground")
ENEMY_GROUP = hash("enemy")
PLAYER_GROUP = hash("player")

function do_init(self)
    self.velocity = vmath.vector3(0, 0, 0)
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


function play_animation(self, animation)
    if self.current_animation ~= animation then
        self.current_animation = animation
        msg.post("#sprite", "play_animation", { id = animation })
    end
end


function handle_geometry_contact(self, normal, distance)
    local proj = vmath.dot(self.correction, normal)
    local comp = (distance - proj) * normal
    self.correction = self.correction + comp
    go.set_position(go.get_position() + comp)
    self.ground_angle_y = normal.y
    self.ground_angle_x = normal.x
    if normal.y > 0.7 then
        self.ground_contact = true
    end
    proj = vmath.dot(self.velocity, normal)
    if proj < 0 then
        -- remove that component in that case
        self.velocity = self.velocity - proj * normal
        self.velocity.x = 0
    end
end



