const std = @import("std");
const input = @embedFile("./input.txt");
const expect = std.testing.expect;

const House = struct {
    x: i32,
    y: i32,
    visit_count: u32,

    pub fn init(x: i32, y: i32) House {
        return House{ .x = x, .y = y, .visit_count = 1 };
    }
};

fn getHousesCount(comptime length: usize, content: *const [length]u8) usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var houses = std.ArrayList(House).init(gpa.allocator());

    var x: i32 = 0;
    var y: i32 = 0;

    // start location is always x=0 y=0
    houses.append(House.init(x, y)) catch unreachable;

    for (content) |byte| {
        switch (byte) {
            '<' => x -= 1,
            '>' => x += 1,
            '^' => y -= 1,
            'v' => y += 1,
            else => unreachable,
        }
        var house_found = false;
        for (houses.items) |*house| {
            if (house.x == x and house.y == y) {
                house.visit_count += 1;
                house_found = true;
            }
        }
        if (!house_found) {
            houses.append(House.init(x, y)) catch unreachable;
        }
    }
    return houses.items.len;
}

pub fn main() void {
    const houses_count = getHousesCount(input.len, input);
    std.log.debug("Visited houses: {d}", .{houses_count});
}

test "`>` delivers presents to `2` houses" {
    var a: *const [1]u8 = ">";
    try expect(getHousesCount(a.len, a) == 2);
}

test "`^>v<` delivers presents to `4` houses" {
    var a: *const [4]u8 = "^>v<";
    try expect(getHousesCount(a.len, a) == 4);
}

test "`^v^v^v^v^v` delivers a bunch of presents to `2` houses" {
    var a: *const [10]u8 = "^v^v^v^v^v";
    try expect(getHousesCount(a.len, a) == 2);
}
