const mandelbrot = @import("mandelbrot.zig");

pub fn compute_row(context: anytype, y: usize) void {
    const width_f = @as(f64, @floatFromInt(context.width));
    const height_f = @as(f64, @floatFromInt(context.height));
    const dx = (context.x_max - context.x_min) / width_f;
    const dy = (context.y_max - context.y_min) / height_f;
    const y0 = context.y_min + @as(f64, @floatFromInt(y)) * dy;

    var offset = y * context.width * 3;

    for (0..context.width) |x| {
        const x0 = context.x_min + @as(f64, @floatFromInt(x)) * dx;
        const iteration = mandelbrot.mandelbrot(x0, y0, context.max_iter);

        if (iteration == context.max_iter) {
            context.pixels[offset] = 0x00;
            context.pixels[offset + 1] = 0x00;
            context.pixels[offset + 2] = 0x00;
        } else {
            context.pixels[offset] = @as(u8, @intCast(iteration % 256));
            context.pixels[offset + 1] = @as(u8, @intCast((iteration * 5) % 256));
            context.pixels[offset + 2] = @as(u8, @intCast((iteration * 13) % 256));
        }
        offset += 3;
    }
}
