// Copyright (c) 2025
// Author: Tommy Breslein (github.com/tbreslein)
// License: GPL-2.0

const idx = @import("aliases.zig").idx;

const Self = @This();

dimensionality: u2,
n_xi: idx,
n_eta: idx = 1,
n_phi: idx = 1,

n_gc: idx = 2,

// n_xi_all: idx = Self.n_xi + 2 * Self.n_gc,
// n_eta_all: idx = Self.n_eta + 2 * Self.n_gc,
// n_phi_all: idx = Self.n_phi + 2 * Self.n_gc,
n_xi_all: idx = undefined,
n_eta_all: idx = undefined,
n_phi_all: idx = undefined,

xi_min: f64,
xi_max: f64,
eta_min: f64 = undefined,
eta_max: f64 = undefined,
phi_min: f64 = undefined,
phi_max: f64 = undefined,

mesh_type: MeshType,

physics_type: PhysicsType,
eq_of_state: EqOfState,
cs_isothermal: f64 = 0.0,

const MeshType = enum {
    cartesian,
    polar,
    log_polar,
};

const PhysicsType = enum {
    euler,
    navier_stokes,
};

const EqOfState = enum {
    isothermal,
    adiabatic,
};

pub fn validate(comptime self: Self) void {
    if (self.cs_isothermal == 0.0 and self.eq_of_state == .isothermal)
        @compileError("Config validation error: When Config.eq_of_state == .isothermal, then Config.cs_isothermal needs to be set.");
    if (self.cs_isothermal <= 0.0) @compileError("Config validation error: Config.cs_isothermal must be > 0");

    switch (self.dimensionality) {
        1...3 => {
            if (self.dimensionality > 1) {
                if (self.n_eta == undefined)
                    @compileError("Config validation error: When Config.dimensionality > 1, then Config.n_eta needs to be set.");
                if (self.eta_min == undefined)
                    @compileError("Config validation error: When Config.dimensionality > 1, then Config.eta_min needs to be set.");
                if (self.eta_max == undefined)
                    @compileError("Config validation error: When Config.dimensionality > 1, then Config.eta_max needs to be set.");
            }
            if (self.dimensionality > 2) {
                if (self.n_phi == undefined)
                    @compileError("Config validation error: When Config.dimensionality > 2, then Config.n_phi needs to be set.");
                if (self.phi_min == undefined)
                    @compileError("Config validation error: When Config.dimensionality > 2, then Config.phi_min needs to be set.");
                if (self.phi_max == undefined)
                    @compileError("Config validation error: When Config.dimensionality > 2, then Config.phi_max needs to be set.");
            }
        },
        else => @compileError("Config validation error: Config.dimensionality must be > 0 and < 4."),
    }

    if (self.n_xi == 0) @compileError("Config validation error: Config.n_xi must be > 0");
    if (self.n_eta == 0) @compileError("Config validation error: Config.n_eta must be > 0");
    if (self.n_phi == 0) @compileError("Config validation error: Config.n_phi must be > 0");
}
