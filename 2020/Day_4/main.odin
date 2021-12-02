package main

import "core:fmt"
import "core:os"
import "core:strings"

import "../util"

/*

    byr (Birth Year) - four digits; at least 1920 and at most 2002.
    iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    hgt (Height) - a number followed by either cm or in:
        If cm, the number must be at least 150 and at most 193.
        If in, the number must be at least 59 and at most 76.
    hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    pid (Passport ID) - a nine-digit number, including leading zeroes.
    cid (Country ID) - ignored, missing or not.
*/


Passport :: map[string]string;
main :: proc()
{
    using util;
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    passports:= make([dynamic]Passport);
    label, value: string;
    for
    {
        p := make(Passport);
        for
        {
            ok: bool;
            ok = read_fmt(&input, "%s:%W%c", &label, &value);
            if !ok do break;
            p[label] = value;
        }
        append(&passports, p);
        
        ok := read_fmt(&input, "%>");
        if !ok do break;
    }
    
    fields := [?]string{
        "byr",
        "iyr",
        "eyr",
        "hgt",
        "hcl",
        "ecl",
        "pid",
        // "cid",
    };
    
    ecls := [?]string{"amb", "blu", "brn", "gry", "grn", "hzl", "oth"};
    
    valid := 0;
    outer: for p in passports
    {
        hgt: int; hgt_suffix: string;
        hcl: int;
        pid: int;
        
        val: string;
        ok: bool;
        
        val, ok = p["byr"];
        if !ok ||
            len(val) != 4 ||
            val < "1920" || val > "2002" do 
            continue;
        
        val, ok = p["iyr"];
        if !ok ||
            len(val) != 4 ||
            val < "2010" || val > "2020" do 
            continue;
        
        val, ok = p["eyr"];
        if !ok ||
            len(val) != 4 ||
            val < "2020" || val > "2030" do 
            continue;
        
        val, ok = p["hgt"];
        if !ok do continue;
        ok = read_fmt(&val, "%d%s", &hgt, &hgt_suffix);
        if !ok do continue;
        if hgt_suffix == "cm" &&
            (hgt < 150 || hgt > 193) do
            continue;
        else if hgt_suffix == "in" &&
            (hgt < 59 || hgt > 76) do
            continue;
        else if hgt_suffix != "in" && hgt_suffix != "cm" do
            continue;
        
        val, ok = p["hcl"];
        if !ok || val[0] != '#' || len(val) != 7 do continue;
        val = val[1:];
        for _,i in val
        {
            switch val[i]
            {
                case 'a'..'z','A'..'Z','0'..'9': continue;
                case: continue outer;
            }
        }
        
        val, ok = p["ecl"];
        if !ok do continue;
        ok = false;
        for ecl in ecls do
            if val == ecl do ok = true;
        if !ok do continue;
        
        val, ok = p["pid"];
        if !ok || len(val) != 9 do continue;
        ok = read_fmt(&val, "%d", &pid);
        if !ok || len(val)!= 0 do continue;
        
        valid += 1;
    }
    
    fmt.println(valid);
}