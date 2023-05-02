const std = @import("std");
const input = @embedFile("./input.txt");
const expect = std.testing.expect;

fn getBasementPosition(comptime length: usize, instruction: *const [length]u8) i32 {
    // start at floor 0
    var floor: i32 = 0;
    var position: i32 = 0;
    for (instruction) |byte| {
        switch (byte) {
            // floor up on (
            '(' => floor += 1,
            // floor down on )
            ')' => floor -= 1,
            else => unreachable,
        }
        position += 1;
        if (floor == -1) {
            break;
        }
    }
    return position;
}

pub fn main() void {
    std.log.debug("Basement position: {d}", .{getBasementPosition(input.len, input)});
}

test "`)` causes him to enter the basement at character position `1`" {
    var a: *const [1]u8 = ")";
    try expect(getBasementPosition(a.len, a) == 1);
}

test "`()())` causes him to enter the basement at character position `5`" {
    var a: *const [5]u8 = "()())";
    try expect(getBasementPosition(a.len, a) == 5);
}
