const std = @import("std");
const input = @embedFile("./input.txt");
const expect = std.testing.expect;

const House = struct {
    x: i32,
    y: i32,
    visit_count: u32,

    pub fn init(x: i32, y: i32, visit_count: u32) House {
        return House{ .x = x, .y = y, .visit_count = visit_count };
    }
};

fn getHousesCount(comptime length: usize, content: *const [length]u8) usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var houses = std.ArrayList(House).init(gpa.allocator());

    var x: i32 = 0;
    var y: i32 = 0;

    var x_robot: i32 = 0;
    var y_robot: i32 = 0;

    // start location is always x=0 y=0
    houses.append(House.init(x, y, 2)) catch unreachable;

    var i: i32 = 0;
    for (content) |byte| {
        var x_mod: i32 = 0;
        var y_mod: i32 = 0;
        const is_robot = @rem(i, 2) == 0;

        if (!is_robot) {
            x_mod = x;
            y_mod = y;
        } else {
            x_mod = x_robot;
            y_mod = y_robot;
        }

        switch (byte) {
            '<' => x_mod -= 1,
            '>' => x_mod += 1,
            '^' => y_mod -= 1,
            'v' => y_mod += 1,
            else => unreachable,
        }

        // the santas take turns in moving, so every 2nd move is santa
        var house_found = false;
        for (houses.items) |*house| {
            if (house.x == x_mod and house.y == y_mod) {
                house.visit_count += 1;
                house_found = true;
            }
        }
        if (!house_found) {
            houses.append(House.init(x_mod, y_mod, 1)) catch unreachable;
        }

        if (!is_robot) {
            x = x_mod;
            y = y_mod;
        } else {
            x_robot = x_mod;
            y_robot = y_mod;
        }
        i += 1;
    }
    return houses.items.len;
}

pub fn main() void {
    const houses_count = getHousesCount(input.len, input);
    std.log.debug("Visited houses: {d}", .{houses_count});
}

test "`^v` delivers presents to `3` houses" {
    var a: *const [2]u8 = "^v";
    try expect(getHousesCount(a.len, a) == 3);
}

test "`^>v<` now delivers presents to `3` houses" {
    var a: *const [4]u8 = "^>v<";
    try expect(getHousesCount(a.len, a) == 3);
}

test "`^v^v^v^v^v` now delivers presents to `11` houses" {
    var a: *const [10]u8 = "^v^v^v^v^v";
    try expect(getHousesCount(a.len, a) == 11);
}
