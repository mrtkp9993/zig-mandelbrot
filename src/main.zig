const std = @import("std");

pub fn main() !void {
    const gpa = std.heap.page_allocator;

    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    if (args.len < 3) return error.NotEnoughArgs;

    const width = try std.fmt.parseInt(u32, args[1], 10);
    const height = try std.fmt.parseInt(u32, args[2], 10);
    const max_iter = 256;
    const x_min = -2.0;
    const x_max = 1.0;
    const y_min = -1.5;
    const y_max = 1.5;

    const file = try std.fs.cwd().createFile("output.ppm", .{});
    defer file.close();
    const writer = file.writer();
    // PPM file header
    try writer.print("P6\n{d} {d}\n{d}\n", .{ width, height, 255 });

    std.debug.print("Starting to calculate...\n", .{});
    var timer = try std.time.Timer.start();
    for (0..height) |y| {
        for (0..width) |x| {
            const x0 = x_min + (@as(f64, @floatFromInt(x)) / @as(f64, @floatFromInt(width))) * (x_max - x_min);
            const y0 = y_min + (@as(f64, @floatFromInt(y)) / @as(f64, @floatFromInt(height))) * (y_max - y_min);
            const iteration = mandelbrot(x0, y0, max_iter);
            if (iteration == max_iter) {
                try writer.writeByte(0x00);
                try writer.writeByte(0x00);
                try writer.writeByte(0x00);
            } else {
                const r = @as(u8, @intCast(iteration % 256));
                const g = @as(u8, @intCast((iteration * 5) % 256));
                const b = @as(u8, @intCast((iteration * 13) % 256));
                try writer.writeByte(r);
                try writer.writeByte(g);
                try writer.writeByte(b);
            }
        }
    }
    const elapsed = timer.read();
    const elapsed_ms = @as(f64, @floatFromInt(elapsed)) / 1_000_000.0;
    std.debug.print("File saved to output.ppm in {d:.2} ms.\n", .{elapsed_ms});
}

fn mandelbrot(x0: f64, y0: f64, max_iter: u32) u32 {
    var x: f64 = 0.0;
    var y: f64 = 0.0;
    var iteration: u32 = 0;

    while (x * x + y * y <= 4.0 and iteration < max_iter) : (iteration += 1) {
        const xtemp = x * x - y * y + x0;
        y = 2.0 * x * y + y0;
        x = xtemp;
    }

    return iteration;
}
