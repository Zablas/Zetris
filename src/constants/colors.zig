const rl = @import("raylib");

pub const dark_blue = rl.Color{ .r = 44, .g = 44, .b = 127, .a = 255 };
pub const dark_grey = rl.Color{ .r = 26, .g = 31, .b = 40, .a = 255 };
pub const green = rl.Color{ .r = 47, .g = 230, .b = 23, .a = 255 };
pub const red = rl.Color{ .r = 232, .g = 18, .b = 18, .a = 255 };
pub const orange = rl.Color{ .r = 226, .g = 116, .b = 17, .a = 255 };
pub const yellow = rl.Color{ .r = 237, .g = 234, .b = 4, .a = 255 };
pub const purple = rl.Color{ .r = 166, .g = 0, .b = 247, .a = 255 };
pub const cyan = rl.Color{ .r = 21, .g = 204, .b = 209, .a = 255 };
pub const blue = rl.Color{ .r = 13, .g = 64, .b = 216, .a = 255 };

pub fn getAllColors() [8]rl.Color {
    return [8]rl.Color{
        dark_grey,
        green,
        red,
        orange,
        yellow,
        purple,
        cyan,
        blue,
    };
}
