const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const input = @embedFile("./input.txt");

const Instruction = struct {
    x_start: u32,
    y_start: u32,
    x_end: u32,
    y_end: u32,
    operation: []const u8,
    action: ?[]const u8,
};

pub fn main() !void {
    var lights = [_][1000]bool{[_]bool{false} ** 1000} ** 1000;
    var input_tokenizer = mem.tokenize(u8, input, "\n");

    while (input_tokenizer.next()) |line| {
        var instruction: Instruction = try parseInstruction(line);
        applyInstruction(instruction, &lights);
    }

    std.debug.print("Solution: {d}\n", .{countLights(lights)});
}

fn parseInstruction(line: []const u8) !Instruction {
    var instruction: Instruction = undefined;

    var line_tokenizer = mem.tokenize(u8, line, " ");

    instruction.operation = line_tokenizer.next().?;
    instruction.action = if (mem.eql(u8, instruction.operation, "turn")) line_tokenizer.next().? else null;

    var coord_start = mem.tokenize(u8, line_tokenizer.next().?, ",");

    instruction.x_start = try fmt.parseInt(u16, coord_start.next().?, 10);
    instruction.y_start = try fmt.parseInt(u16, coord_start.next().?, 10);

    _ = line_tokenizer.next();

    var coord_end = mem.tokenize(u8, line_tokenizer.next().?, ",");
    instruction.x_end = try fmt.parseInt(u16, coord_end.next().?, 10);
    instruction.y_end = try fmt.parseInt(u16, coord_end.next().?, 10);

    return instruction;
}

fn applyInstruction(instruction: Instruction, lights: *[1000][1000]bool) void {
    var x = instruction.x_start;
    while (x <= instruction.x_end) : (x += 1) {
        var y = instruction.y_start;
        while (y <= instruction.y_end) : (y += 1) {
            if (mem.eql(u8, instruction.operation, "toggle")) {
                lights[x][y] = !lights[x][y];
            } else {
                lights[x][y] = mem.eql(u8, instruction.action.?, "on");
            }
        }
    }
}

fn countLights(lights: [1000][1000]bool) u32 {
    var lights_count: u32 = 0;
    var x: usize = 0;
    while (x < 1000) : (x += 1) {
        var y: usize = 0;
        while (y < 1000) : (y += 1) {
            if (lights[x][y]) {
                lights_count += 1;
            }
        }
    }
    return lights_count;
}
