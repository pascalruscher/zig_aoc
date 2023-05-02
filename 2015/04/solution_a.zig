const std = @import("std");
const shared = @import("shared.zig");

pub fn main() !void {
    const input = "yzbqklnj";

    std.debug.print("Solution a: {!d}\n", .{shared.getSecretAnswer(input, 5)});
}
