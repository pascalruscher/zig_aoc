const std = @import("std");
const Md5 = std.crypto.hash.Md5;
const mem = std.mem;
const fmt = std.fmt;
const expect = std.testing.expect;

pub fn main() void {
    const input = "yzbqklnj";
    const xy: u32 = 2;
    const testd = [_]u32{xy};
    const testd2 = input ++ testd;
    std.log.debug("{}", testd2);
    var hashed = [_]u8{0} ** Md5.digest_length;

    var i: u32 = 1;
    var found = false;
    while (!found) : (i += 1) {
        const is = [_]u32{i};
        const testx = input ++ is;
        Md5.hash(testx, &hashed, .{});
        found = mem.bytesAsValue(u32, hashed[0..4]).* == 0;
    }
    std.log.debug("Solution: {d}", .{i});
}
