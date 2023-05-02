const std = @import("std");
const shared = @import("shared.zig");

pub fn main() !void {
    const input = "yzbqklnj";

    std.debug.print("Solution b: {!d}", .{shared.getSecretAnswer(input, 6)});
}
