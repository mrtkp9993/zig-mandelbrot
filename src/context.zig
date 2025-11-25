pub const Context = struct {
    width: u64,
    height: u64,
    x_min: f64,
    x_max: f64,
    y_min: f64,
    y_max: f64,
    max_iter: u32,
    pixels: []u8,
};
