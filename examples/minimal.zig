// Copyright (c) 2025
// Author: Tommy Breslein (github.com/tbreslein)
// License: GPL-2.0

const std = @import("std");
const shyr = @import("shyr");
const Config = shyr.Config;

pub fn main() !void {
    shyr.run(Config{
        .dimensionality = 1,
        .n_xi = 10,
        .xi_min = 1.0,
        .xi_max = 2.0,
        .mesh_type = .cartesian,
        .physics_type = .euler,
        .eq_of_state = .isothermal,
        .cs_isothermal = 1.0,
    });
}
