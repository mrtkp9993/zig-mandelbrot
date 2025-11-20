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
