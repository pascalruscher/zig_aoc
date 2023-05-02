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
            if (total_count >= required) {
                return true;
            }
        }
    }
    return false;
}

fn hasDouble(line: []const u8) bool {
    for (line[1..], 1..) |c, i| {
        if (c == line[i - 1]) {
            return true;
        }
    }
    return false;
}

fn hasIllegal(line: []const u8) bool {
    const illegals = [_][]const u8{ "ab", "cd", "pq", "xy" };
    for (illegals) |illegal| {
        if (mem.indexOf(u8, line, illegal) != null) {
            return true;
        }
    }
    return false;
}

test "hasVowels aei returns true" {
    try std.testing.expect(hasVowels("aei", 3) == true);
}

test "hasVowels xazegov returns true" {
    try std.testing.expect(hasVowels("xazegov", 3) == true);
}

test "hasVowels aeiouaeiouaeiou returns true" {
    try std.testing.expect(hasVowels("aeiouaeiouaeiou", 4) == true);
}

test "hasVowels gggg returns false" {
    try std.testing.expect(hasVowels("gggg", 1) == false);
}

test "hasVowels gaag returns false" {
    try std.testing.expect(hasVowels("gaag", 3) == false);
}

test "hasDouble xx returns true" {
    try std.testing.expect(hasDouble("xx") == true);
}

test "hasDouble abcdde returns true" {
    try std.testing.expect(hasDouble("abcdde") == true);
}

test "hasDouble aabbccdd returns true" {
    try std.testing.expect(hasDouble("aabbccdd") == true);
}

test "hasDouble fafafafa returns false" {
    try std.testing.expect(hasDouble("fafafafa") == false);
}

test "hasIllegal baab returns true" {
    try std.testing.expect(hasIllegal("baab") == true);
}

test "hasIllegal cdjlkma returns true" {
    try std.testing.expect(hasIllegal("cdjlkma") == true);
}

test "hasIllegal aaaaa returns false" {
    try std.testing.expect(hasIllegal("aaaaa") == false);
}

test "isNiceString ugknbfddgicrmopn returns true" {
    try std.testing.expect(isNiceString("ugknbfddgicrmopn") == true);
}

test "isNiceString aaa returns true" {
    try std.testing.expect(isNiceString("ugknbfddgicrmopn") == true);
}

test "isNiceString jchzalrnumimnmhp returns false" {
    try std.testing.expect(isNiceString("jchzalrnumimnmhp") == false);
}

test "isNiceString haegwjzuvuyypxyu returns false" {
    try std.testing.expect(isNiceString("haegwjzuvuyypxyu") == false);
}

test "isNiceString dvszwmarrgswjxmb returns false" {
    try std.testing.expect(isNiceString("dvszwmarrgswjxmb") == false);
}
