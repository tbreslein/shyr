// Copyright (c) 2025
// Author: Tommy Breslein (github.com/tbreslein)
// License: GPL-2.0

//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub const Config = @import("config.zig");

pub fn run(comptime c: Config) void {
    comptime c.validate();

    std.debug.print("{}\n", .{c});
}

// test "basic add functionality" {
//     try testing.expect(add(3, 7) == 10);
// }
