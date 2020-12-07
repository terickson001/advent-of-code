package main

import "core:fmt"
import "core:os"

import "../util"

Entry :: struct
{
    min, max: int,
    char: u8,
    pass: string,
}

main :: proc()
{
    using util;
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    entries := make([dynamic]Entry);
    entry: Entry;
    for
    {
        ok := read_fmt(&input, "%d-%d %c: %s%>", 
                       &entry.min, &entry.max,
                       &entry.char, &entry.pass
                       );
        
        if !ok do break;
        append(&entries, entry);
    }
    
    valid := 0;
    for e in entries
    {
        a := e.pass[e.min-1] == e.char;
        b := e.pass[e.max-1] == e.char;
        if (a || b) && !(a && b) do
            valid += 1;
    }
    fmt.println(valid);
}