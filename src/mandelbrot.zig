const std = @import("std");

pub fn mandelbrot(x0: f64, y0: f64, max_iter: u32) u32 {
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

const TestCase = struct {
    x: f64,
    y: f64,
    expected_iter: u32,
};

const test_cases = [_]TestCase{
    .{ .x = 0.205, .y = -0.560, .expected_iter = 62 },
    .{ .x = 0.225, .y = -0.560, .expected_iter = 18 },
    .{ .x = 0.245, .y = -0.560, .expected_iter = 344 },
    .{ .x = 0.205, .y = -0.540, .expected_iter = 512 },
    .{ .x = 0.225, .y = -0.540, .expected_iter = 24 },
    .{ .x = 0.245, .y = -0.540, .expected_iter = 512 },
    .{ .x = 0.205, .y = -0.520, .expected_iter = 512 },
    .{ .x = 0.225, .y = -0.520, .expected_iter = 512 },
    .{ .x = 0.245, .y = -0.520, .expected_iter = 512 },
};

test "mandelbrot" {
    for (test_cases) |tc| {
        const result = mandelbrot(tc.x, tc.y, 512);
        try std.testing.expect(result == tc.expected_iter);
    }
}
