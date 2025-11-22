const mandelbrot = @import("mandelbrot.zig");

pub fn compute_row(context: anytype, y: usize) void {
    const width = context.width;
    const width_f = @as(f64, @floatFromInt(width));
    const x_min = context.x_min;
    const x_scale = (context.x_max - x_min) / width_f;

    const height_f = @as(f64, @floatFromInt(context.height));
    const y0 = context.y_min + (@as(f64, @floatFromInt(y)) / height_f) * (context.y_max - context.y_min);

    const row_offset = y * width * 3;

    for (0..width) |x| {
        const x0 = x_min + x_scale * @as(f64, @floatFromInt(x));
        const iteration = mandelbrot.mandelbrot(x0, y0, context.max_iter);

        const offset = row_offset + x * 3;
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
