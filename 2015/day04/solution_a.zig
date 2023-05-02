const std = @import("std");
const Md5 = std.crypto.hash.Md5;
const mem = std.mem;
const fmt = std.fmt;
const heap = std.heap;

pub fn main() !void {
    const input = "yzbqklnj";

    std.debug.print("Solution: {!d}", .{getSecretAnswer(input)});
}

pub fn getSecretAnswer(input: []const u8) !usize {
    var hashed = [_]u8{1} ** Md5.digest_length;

    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var i: usize = 1;
    while (true) : (i += 1) {
        const concat = try fmt.allocPrint(allocator, "{s}{d}", .{ input, i });

        Md5.hash(concat, &hashed, .{});
        if (mem.eql(u8, fmt.bytesToHex(hashed, fmt.Case.lower)[0..5], "00000")) {
            break;
        }
    }

    return i;
}

test "getSecretAnswer for abcdef" {
    const secret = try getSecretAnswer("abcdef");
    try std.testing.expect(secret == 609043);
}

test "getSecretAnswer for pqrstuv" {
    const secret = try getSecretAnswer("pqrstuv");
    try std.testing.expect(secret == 1048970);
}
