# Rawterm-zig

Enter and exit terminal raw mode

## Example

```zig
const std = @import("std");
const rawterm = @import("rawterm");

pub fn main() anyerror!void {
    try rawterm.raw();
    defer rawterm.rawOff() catch unreachable;
    try std.io.getStdOut().writer().print("In raw mode!\n", .{});
}
```
