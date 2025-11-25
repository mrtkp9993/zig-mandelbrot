const std = @import("std");

const mandelbrot = @import("mandelbrot.zig");

pub fn compute_row(context: anytype, y: usize, wait_group: *std.Thread.WaitGroup) void {
    defer wait_group.finish();
    for (0..context.width) |x| {
        const x0 = context.x_min + (@as(f64, @floatFromInt(x)) / @as(f64, @floatFromInt(context.width))) * (context.x_max - context.x_min);
        const y0 = context.y_min + (@as(f64, @floatFromInt(y)) / @as(f64, @floatFromInt(context.height))) * (context.y_max - context.y_min);
        const iteration = mandelbrot.mandelbrot(x0, y0, context.max_iter);

        const offset = (y * context.width + x) * 3;
        if (iteration == context.max_iter) {
            context.pixels[offset] = 0x00;
            context.pixels[offset + 1] = 0x00;
            context.pixels[offset + 2] = 0x00;
        } else {
            context.pixels[offset] = @as(u8, @intCast(iteration % 256));
            context.pixels[offset + 1] = @as(u8, @intCast((iteration * 5) % 256));
            context.pixels[offset + 2] = @as(u8, @intCast((iteration * 13) % 256));
        }
    }
}
