package main

import "core:fmt"
import "core:os"
import "core:strings"

import "../util"


main :: proc()
{
    using util;
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    passes := make([dynamic]string);
    pass: string;
    for
    {
        ok := read_fmt(&input, "%s%>", &pass);
        if !ok do break;
        append(&passes, pass);
    }
    
    max_id := 0;
    seats: [128*8]b8;
    
    for p in passes
    {
        range: [2][2]int;
        range.x[1] = 7;
        range.y[1] = 127;
        
        for c,i in p
        {
            switch c
            {
                case 'F': range.y[1] -= (range.y[1]-range.y[0]+1) / 2;
                case 'B': range.y[0] += (range.y[1]-range.y[0]+1) / 2;
                
                case 'L': range.x[1] -= (range.x[1]-range.x[0]+1) / 2;
                case 'R': range.x[0] += (range.x[1]-range.x[0]+1) / 2;
            }
        }
        assert(range.y[0] == range.y[1] && range.x[0] == range.x[1]);
        id := range.y[0]*8 + range.x[0];
        seats[id] = true;
        max_id = max(id, max_id);
    }
    
    first_seat := false;
    for s,i in seats
    {
        if bool(!s) && first_seat
        {
            fmt.println(i);
            break;
        }
        else if s
        {
            first_seat = true;
        }
    }
}