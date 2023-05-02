const std = @import("std");
const input = @embedFile("./input.txt");
const expect = std.testing.expect;

fn calculateSquareFeet(length: i32, width: i32, height: i32) i32 {
    const sides: [3]i32 = .{ length * width, width * height, height * length };
    var smallest: i32 = std.math.maxInt(i32);
    for (sides) |side| {
        if (side < smallest) {
            smallest = side;
        }
    }
    return 2 * sides[0] + 2 * sides[1] + 2 * sides[2] + smallest;
}

fn getTotalSquareFeet(comptime length: usize, content: *const [length]u8) i32 {
    var squareFeet: i32 = 0;
    var lines = std.mem.tokenize(u8, content, "\r\n");
    while (lines.next()) |line| {
        var numbers = std.mem.tokenize(u8, line, "x");
        var measurements: [3]i32 = undefined;
        var i: usize = 0;
        while (numbers.next()) |number| {
            const num = std.fmt.parseInt(i32, number, 10) catch continue;
            measurements[i] = num;
            i += 1;
        }
        squareFeet += calculateSquareFeet(measurements[0], measurements[1], measurements[2]);
    }
    return squareFeet;
}

pub fn main() void {
    const squareFeet = getTotalSquareFeet(input.len, input);
    std.log.debug("Square feet: {d}", .{squareFeet});
}

test "A present with dimensions `2x3x4` requires a total of `58` square feet" {
    try expect(calculateSquareFeet(2, 3, 4) == 58);
}

test "A present with dimensions `1x1x10` requires a total of `43` square feet" {
    try expect(calculateSquareFeet(1, 1, 10) == 43);
}
