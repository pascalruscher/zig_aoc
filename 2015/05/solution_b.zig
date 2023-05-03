const std = @import("std");
const mem = std.mem;
const input = @embedFile("./input.txt");

pub fn main() void {
    const line_length = 17;
    var count_nice_strings: usize = 0;

    var i: usize = 0;
    while (i < input.len) : (i += line_length) {
        if (isNiceString(input[i .. i + line_length - 1])) {
            count_nice_strings += 1;
        }
    }

    std.debug.print("Solution: {d}\n", .{count_nice_strings});
}

fn isNiceString(line: []const u8) bool {
    return hasPair(line) and hasSameCharWithOtherBetween(line);
}

fn hasPair(line: []const u8) bool {
    const len = line.len;

    var i: usize = 0;
    while (i < len - 2) : (i += 1) {
        const a = line[i];
        const b = line[i + 1];

        var j: usize = i + 2;
        while (j < len - 1) : (j += 1) {
            const c = line[j];
            const d = line[j + 1];
            if (a == c and b == d) return true;
        }
    }
    return false;
}

fn hasSameCharWithOtherBetween(line: []const u8) bool {
    const len = line.len;

    var i: usize = 0;
    while (i < len - 2) : (i += 1) {
        const a = line[i];
        const c = line[i + 2];
        if (a == c) return true;
    }
    return false;
}

test "isNiceString" {
    try std.testing.expect(isNiceString("qjhvhtzxzqqjkmpb") == true);
    try std.testing.expect(isNiceString("xxyxx") == true);
    try std.testing.expect(isNiceString("uurcxstgmygtbstg") == false);
    try std.testing.expect(isNiceString("ieodomkazucvgmuy") == false);
}

test "hasPair" {
    try std.testing.expect(hasPair("xyxy") == true);
    try std.testing.expect(hasPair("aabcdefgaa") == true);
    try std.testing.expect(hasPair("aaa") == false);
}

test "hasSameCharWithOtherBetween" {
    try std.testing.expect(hasSameCharWithOtherBetween("xyx") == true);
    try std.testing.expect(hasSameCharWithOtherBetween("abcdefeghi") == true);
    try std.testing.expect(hasSameCharWithOtherBetween("aaa") == true);
}
