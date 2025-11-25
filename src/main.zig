const std = @import("std");

const compute_row = @import("compute_row.zig");
const context = @import("context.zig");

pub fn main() !void {
    const gpa = std.heap.page_allocator;

    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    if (args.len < 3) return error.NotEnoughArgs;

    const width = try std.fmt.parseInt(u32, args[1], 10);
    const height = try std.fmt.parseInt(u32, args[2], 10);
    const pixels = try gpa.alloc(u8, width * height * 3);

    const ctx = context.Context{
        .width = width,
        .height = height,
        .max_iter = 256,
        .x_min = -2.0,
        .x_max = 1.0,
        .y_min = -1.5,
        .y_max = 1.5,
        .pixels = pixels,
    };

    var thread_pool: std.Thread.Pool = undefined;
    try thread_pool.init(.{ .allocator = gpa });
    defer thread_pool.deinit();

    var wait_group: std.Thread.WaitGroup = undefined;
    wait_group.reset();

    std.debug.print("Starting to calculate...\n", .{});
    var timer = try std.time.Timer.start();
    for (0..height) |y| {
        wait_group.start();
        try thread_pool.spawn(compute_row.compute_row, .{ ctx, y, &wait_group });
    }
    thread_pool.waitAndWork(&wait_group);

    const elapsed = timer.read();
    const elapsed_ms = @as(f64, @floatFromInt(elapsed)) / 1_000_000.0;
    std.debug.print("Calculation done in {d:.2} ms.\n", .{elapsed_ms});

    const file = try std.fs.cwd().createFile("output.ppm", .{});
    defer file.close();
    var buf: [4096]u8 = undefined;
    var writer = std.fs.File.writer(file, buf[0..]);
    try writer.interface.print("P6\n{d} {d}\n{d}\n", .{ width, height, 255 });
    try writer.interface.writeAll(ctx.pixels);
    try writer.interface.flush();
    std.debug.print("File saved to output.ppm.\n", .{});
}
