package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:math/linalg"
import "../util"

input := string(#load("input"))


Line :: struct
{
    a: [2]i32,
    b: [2]i32,
}

Item :: Line;

main :: proc()
{
    using util;
    
    items := make([dynamic]Item);
    item: Item;
    for
    {
        ok := read_fmt(&input, "%d,%d -> %d,%d\n", 
                       &item.a.x, &item.a.y,
                       &item.b.x, &item.b.y);
        if !ok do break;
        append(&items, item);
    }
    
    part1(items[:]);
    part2(items[:]);
}

print_line :: proc(line: Line)
{
    fmt.println(line.a.x, line.a.y, "->", line.b.x, line.b.y);
}

between :: proc(a, b, p: [2]i32) -> bool
{
    min_x := min(a.x, b.x);
    max_x := max(a.x, b.x);
    min_y := min(a.y, b.y);
    max_y := max(a.y, b.y);
    
    return min_x <= p.x && p.x <= max_x && min_y <= p.y && p.y <= max_y;
}

vert :: proc(l: Line) -> bool do return l.a.x == l.b.x;
hori :: proc(l: Line) -> bool do return l.a.y == l.b.y;

find_intersections :: proc(a, b: Line, hits: ^map[[2]i32]bool) -> bool
{
    if vert(a) && vert(b) // vertical
    {
        if a.a.x != b.b.x do return false; // not co-linear
        if !between(a.a, a.b, b.a) && !between(a.a, a.b, b.b) && 
            !between(b.a, b.b, a.a) { return false; } // disjoint
        
        ys := [4]i32{a.a.y, a.b.y, b.a.y, b.b.y};
        slice.sort(ys[:]);
        for y in ys[1]..ys[2] do hits[[2]i32{a.a.x, y}] = true;
        return true;
    }
    
    if hori(a) && hori(b) // horizontal
    {
        if a.a.y != b.b.y do return false; // not co-linear
        if !between(a.a, a.b, b.a) && !between(a.a, a.b, b.b) && 
            !between(b.a, b.b, a.a) { return false; } // disjoint
        
        xs := [4]i32{a.a.x, a.b.x, b.a.x, b.b.x};
        slice.sort(xs[:]);
        for x in xs[1]..xs[2] do hits[[2]i32{x, a.a.y}] = true;
        return true;
    }
    
    if vert(a) && hori(b) && between(a.a, a.b, [2]i32{a.a.x, b.a.y})
    {
        hits[[2]i32{a.a.x, b.a.y}] = true;
        return true;
    }
    
    if hori(a) && vert(b) && between(a.a, a.b, [2]i32{b.a.x, a.a.y})
    {
        hits[[2]i32{b.a.x, a.a.y}] = true;
        return true;
    }
    
    return false;
}

part1 :: proc(lines: []Item)
{
    hits: map[[2]i32]bool;
    for line, i in lines
    {
        if !(vert(line) || hori(line)) do continue;
        for lineb in lines[i+1:]
        {
            if !(vert(lineb) || hori(lineb)) do continue;
            found := find_intersections(line, lineb, &hits);
        }
    }
    
    fmt.println(len(hits));
}

part2 :: proc(lines: []Item)
{
    
}