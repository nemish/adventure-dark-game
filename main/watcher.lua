function calc_pos(pos)
    return pos - vmath.vector3(450, 270, 0)
end


function get_lerp_position(self)
    return vmath.lerp(0.05, self.pos, calc_pos(self.look_at, pos))
end
