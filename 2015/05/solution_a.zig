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
    return hasVowels(line, 3) and hasDouble(line) and !hasIllegal(line);
}

fn hasVowels(line: []const u8, required: usize) bool {
    var total_count: usize = 0;
    const vowels = [_][]const u8{ "a", "e", "i", "o", "u" };
    for (vowels) |vowel| {
        const vowel_count = mem.count(u8, line, vowel);
        if (vowel_count > 0) {
            total_count += vowel_count;
            if (total_count >= required) return true;
        }
    }
    return false;
}

fn hasDouble(line: []const u8) bool {
    for (line[1..], 1..) |c, i| {
        if (c == line[i - 1]) return true;
    }
    return false;
}

fn hasIllegal(line: []const u8) bool {
    const illegals = [_][]const u8{ "ab", "cd", "pq", "xy" };
    for (illegals) |illegal| {
        if (mem.indexOf(u8, line, illegal) != null) return true;
    }
    return false;
}

test "hasVowels" {
    try std.testing.expect(hasVowels("aei", 3) == true);
    try std.testing.expect(hasVowels("xazegov", 3) == true);
    try std.testing.expect(hasVowels("aeiouaeiouaeiou", 4) == true);
    try std.testing.expect(hasVowels("gggg", 1) == false);
    try std.testing.expect(hasVowels("gaag", 3) == false);
}

test "hasDouble" {
    try std.testing.expect(hasDouble("xx") == true);
    try std.testing.expect(hasDouble("abcdde") == true);
    try std.testing.expect(hasDouble("aabbccdd") == true);
    try std.testing.expect(hasDouble("fafafafa") == false);
}

test "hasIllegal" {
    try std.testing.expect(hasIllegal("baab") == true);
    try std.testing.expect(hasIllegal("cdjlkma") == true);
    try std.testing.expect(hasIllegal("aaaaa") == false);
}

test "isNiceString" {
    try std.testing.expect(isNiceString("ugknbfddgicrmopn") == true);
    try std.testing.expect(isNiceString("ugknbfddgicrmopn") == true);
    try std.testing.expect(isNiceString("jchzalrnumimnmhp") == false);
    try std.testing.expect(isNiceString("haegwjzuvuyypxyu") == false);
    try std.testing.expect(isNiceString("dvszwmarrgswjxmb") == false);
}
