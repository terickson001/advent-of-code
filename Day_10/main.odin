package main

import "core:fmt"
import "core:os"
import "core:slice"

import "../util"

Adapter :: struct
{
    joltage: int,
    
    // Lazy Dynamic Array, could be `[3]^Adapter` with count
    // But I just wanted the ease of using `append`
    in_range: [dynamic]^Adapter, 
}

main :: proc()
{
    using util;
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    adapters := make([dynamic]Adapter);
    adapter: Adapter;
    for
    {
        ok := read_fmt(&input, "%d\n", &adapter.joltage);
        if !ok do break;
        append(&adapters, adapter);
    }
    
    // Add first adapter (Socket)
    adapter.joltage = 0;
    append(&adapters, adapter);
    
    // Sort by joltage
    slice.sort_by(adapters[:], proc(i, j: Adapter) -> bool {return i.joltage < j.joltage});
    
    // Add final adapter (Phone)
    adapter.joltage = adapters[len(adapters)-1].joltage+3; 
    append(&adapters, adapter);
    
    // Find which adapters can connect
    for i in 0..<(len(adapters)-1)
    {
        a := &adapters[i];
        for j in i+1..<min(i+4, len(adapters))
        {
            x := &adapters[j];
            if x.joltage-a.joltage > 3 do break;
            append(&a.in_range, x);
        }
    }
    
    // Initialize memoization storage
    cp_MEM = make([]int, adapters[len(adapters)-1].joltage+1);
    configs := count_paths(&adapters[0]);
    
    fmt.println(configs);
}

cp_MEM: []int;
count_paths :: proc(adapter: ^Adapter) -> int
{
    if cp_MEM[adapter.joltage] != 0 do return cp_MEM[adapter.joltage]; // Memoized
    if len(adapter.in_range) == 0 do return 1; // End
    
    total := 0;
    for connection in adapter.in_range
    {
        total += count_paths(connection);
    }
    cp_MEM[adapter.joltage] = total;
    return total;
}