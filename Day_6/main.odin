package main

import "core:fmt"
import "core:os"
import "core:strings"

import "../util"

Answers :: string;
Group :: [dynamic]Answers;

main :: proc()
{
    using util;
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    groups := make([dynamic]Group);
    answers: Answers;
    for
    {
        group := make(Group);
        for
        {
            ok: bool;
            ok = read_fmt(&input, "%s%c", &answers);
            if !ok do break;
            append(&group, answers);
        }
        append(&groups, group);
        
        ok := read_fmt(&input, "%>");
        if !ok do break;
    }
    
    questions: [26]bool;
    total := 0;
    for g in groups
    {
        questions = [26]bool{};
        for answers,i in g
        {
            if i == 0
            {
                for a in answers do
                    questions[a-'a'] = true;
            }
            else
            {
                for q,c in questions do
                    if q do questions[c] = contains(answers, 'a'+byte(c));
            }
        }
        for q in questions do
            if q do total += 1;
    }
    
    fmt.println(total);
}

contains :: proc(str: string, c: byte) -> bool
{
    for s in str do
        if byte(s) == c do return true;
    return false;
}