package main

import "core:fmt"
import "core:os"
import "core:strings"

import "../util"

Answers :: string;
Group :: [dynamic]Answers;

Bag :: struct
{
    name: string,
    parents: [dynamic]^Bag,
    children: [dynamic]Bag_Count,
}

Bag_Count :: struct
{
    bag: ^Bag,
    count: int,
}

Bags :: map[string]^Bag;

main :: proc()
{
    using util;
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    bags := make(Bags);
    bag: ^Bag;
    for
    {
        name: string;
        ok: bool;
        name, ok = read_bag_name(&input);
        if !ok do break;
        
        bag = get_bag(&bags, name);
        read_fmt(&input, " bags contain ");
        if read_fmt(&input, "no other bags.%>") do
            continue;
        
        child: ^Bag;
        for
        {
            count: int;
            
            ok = read_fmt(&input, "%d ", &count);
            if !ok do break;
            name, ok = read_bag_name(&input);
            delim: byte;
            if count == 1 do
                read_fmt(&input, " bag%c%>", &delim);
            else do
                read_fmt(&input, " bags%c%>", &delim);
            child = get_bag(&bags, name);
            append(&child.parents, bag);
            append(&bag.children, Bag_Count{child, count});
            
            if delim == '.' do break;
        }
        
    }
    
    bag = bags["shiny gold"];
    
    fmt.println(count_children(bag));
}

count_children :: proc(bag: ^Bag) -> int
{
    total := 0;
    for c in bag.children do
        total += c.count + (c.count*count_children(c.bag));
    return total;
}

read_bag_name :: proc(str: ^string) -> (string, bool)
{
    adj, color: string;
    ok := util.read_fmt(str, "%s %s", &adj, &color);
    if !ok do return "", false;
    
    name := fmt.aprintf("%s %s", adj, color);
    return name, true;
}

get_bag :: proc(bags: ^Bags, name: string) -> ^Bag
{
    b, ok := bags[name];
    if !ok
    {
        b = new_clone(Bag{name, nil, nil});
        bags[name] = b;
    }
    return b;
}
