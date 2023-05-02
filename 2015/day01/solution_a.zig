const std = @import("std");
const input = @embedFile("./input.txt");
const expect = std.testing.expect;

fn getFloor(comptime length: usize, instruction: *const [length]u8) i32 {
    // start at floor 0
    var floor: i32 = 0;
    for (instruction) |byte| {
        switch (byte) {
            // floor up on (
            '(' => floor += 1,
            // floor down on )
            ')' => floor -= 1,
            else => unreachable,
        }
    }
    return floor;
}

pub fn main() void {
    std.log.debug("Floor: {d}", .{getFloor(input.len, input)});
}

test "`(())` and `()()` both result in floor `0`" {
    var a: *const [4]u8 = "(())";
    var b: *const [4]u8 = "()()";
    try expect(getFloor(a.len, a) == 0);
    try expect(getFloor(b.len, b) == 0);
}

test "`(((` and `(()(()(` both result in floor `3`" {
    var a: *const [3]u8 = "(((";
    var b: *const [7]u8 = "(()(()(";
    try expect(getFloor(a.len, a) == 3);
    try expect(getFloor(b.len, b) == 3);
}

test "`))(((((` also results in floor `3`" {
    var a: *const [7]u8 = "))(((((";
    try expect(getFloor(a.len, a) == 3);
}

test "`())` and `))(` both result in floor `-1`" {
    var a: *const [3]u8 = "())";
    var b: *const [3]u8 = "))(";
    try expect(getFloor(a.len, a) == -1);
    try expect(getFloor(b.len, b) == -1);
}

test "`)))` and `)())())` both result in floor `-3`" {
    var a: *const [3]u8 = ")))";
    var b: *const [7]u8 = ")())())";
    try expect(getFloor(a.len, a) == -3);
    try expect(getFloor(b.len, b) == -3);
}
