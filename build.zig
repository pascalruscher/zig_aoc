const std = @import("std");

pub fn build(b: *std.Build) !void {
    if (b.args) |args| {
        const target = b.standardTargetOptions(.{});
        const optimize = b.standardOptimizeOption(.{});

        var exe_buf = [_]u8{undefined} ** 9;
        var src_buf = [_]u8{undefined} ** 22;
        const exe_name = try std.fmt.bufPrint(&exe_buf, "{s:0<4}_{s:0>2}_{s}", .{ args[0], args[1], args[2] });
        const src_path = try std.fmt.bufPrint(&src_buf, "{s:0<4}/{s:0>2}/solution_{s}.zig", .{ args[0], args[1], args[2] });

        const exe = b.addExecutable(.{
            .name = exe_name,
            .root_source_file = .{ .path = src_path },
            .target = target,
            .optimize = optimize,
        });

        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);

        run_cmd.step.dependOn(b.getInstallStep());

        run_cmd.addArgs(args);

        const run_step = b.step("run", "Run the app");
        run_step.dependOn(&run_cmd.step);

        const unit_tests = b.addTest(.{
            .root_source_file = .{ .path = src_path },
            .target = target,
            .optimize = optimize,
        });

        const run_unit_tests = b.addRunArtifact(unit_tests);

        const test_step = b.step("test", "Run unit tests");
        test_step.dependOn(&run_unit_tests.step);
    }
}
