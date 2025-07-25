// Copyright (c) 2025
// Author: Tommy Breslein (github.com/tbreslein)
// License: GPL-2.0

const std = @import("std");

const examples = [_][]const u8{
    "minimal",
    "template",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "shyr",
        .root_module = lib_mod,
    });
    b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    inline for (examples) |name| {
        const exe_mod = b.createModule(.{
            .root_source_file = b.path("examples/" ++ name ++ ".zig"),
            .target = target,
            .optimize = optimize,
        });
        exe_mod.addImport("shyr", lib_mod);

        const exe = b.addExecutable(.{
            .name = name,
            .root_module = exe_mod,
        });

        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }
        const run_step = b.step(name, "Run the '" ++ name ++ "' example");
        run_step.dependOn(&run_cmd.step);

        const exe_unit_tests = b.addTest(.{
            .root_module = exe_mod,
        });

        const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
        test_step.dependOn(&run_exe_unit_tests.step);
    }
}
