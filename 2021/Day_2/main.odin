package main

import "core:fmt"
import "core:os"
import "core:math"

import "../util"

input := string(#load("input"))

Instr :: struct
{
    cmd: string,
    n: int,
}

main :: proc()
{
    using util;
    
    instructions:= make([dynamic]Instr);
    instr: Instr;
    for
    {
        ok := read_fmt(&input, "%s %d\n", &instr.cmd, &instr.n);
        if !ok do break;
        append(&instructions, instr);
    }
    
    x, y, aim: int;
    for instr in instructions
    {
        switch instr.cmd
        {
            case "up": aim -= instr.n;
            case "down": aim += instr.n;
            case "forward": 
            x += instr.n;
            y += aim * instr.n;
        }
    }
    
    fmt.println(x*y);
}
