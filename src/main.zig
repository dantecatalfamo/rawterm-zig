const std = @import("std");
const builtin = @import("builtin");
const os = std.os;
const system = os.system;
const testing = std.testing;

pub fn raw() !void {
    var termios = try os.tcgetattr(os.STDIN_FILENO);
    const vmin = if (@hasField(system, "V")) system.V.MIN else std.c.VMIN;
    const vtime = if (@hasField(system, "V")) system.V.TIME else std.c.VTIME;

    termios.iflag &= ~(@as(@TypeOf(termios.iflag), system.IGNBRK |
        system.BRKINT |
        system.IGNPAR |
        system.PARMRK |
        system.INPCK |
        system.ISTRIP |
        system.INLCR |
        system.IGNCR |
        system.ICRNL |
        system.IXON |
        system.IXOFF |
        system.IXANY |
        system.IMAXBEL));
    termios.oflag &= ~(@as(@TypeOf(termios.oflag), system.OPOST));
    termios.lflag &= ~(@as(@TypeOf(termios.lflag), system.ECHO |
        system.ECHOE |
        system.ECHOK |
        system.ECHONL |
        system.ICANON |
        system.ISIG |
        system.IEXTEN
    // | system.XCASE
    ));
    termios.cflag &= ~(@as(@TypeOf(termios.cflag), system.CSIZE | system.PARENB));
    termios.cflag |= (system.CS8);
    termios.cc[vmin] = 1;
    termios.cc[vtime] = 0;

    try os.tcsetattr(os.STDIN_FILENO, system.TCSA.FLUSH, termios);
}

pub fn rawOff() !void {
    var termios = try os.tcgetattr(os.STDIN_FILENO);

    termios.iflag |= (system.BRKINT | system.ISTRIP | system.ICRNL | system.IXON);
    termios.oflag |= (system.OPOST);
    termios.lflag |= (system.ECHO | system.ECHOE | system.ECHOK | system.ECHONL | system.ICANON | system.ISIG | system.IEXTEN);

    try os.tcsetattr(os.STDIN_FILENO, os.TCSA.FLUSH, termios);
}

test "enter and exit raw mode" {
    try raw();
    try rawOff();
}
