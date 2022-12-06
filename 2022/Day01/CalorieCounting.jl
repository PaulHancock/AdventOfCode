

function part1(data)
    best_cals = 0
    this_cals = 0
    for line in data
        l = strip(line)
        if length(l) >0
            this_cals += parse(Int, l)
        else
            best_cals = max(this_cals, best_cals)
            this_cals = 0 
        end
    end
    best_cals = max(this_cals, best_cals)
    return best_cals
end

function part2(data)
    elf_cals = []
    this_cals = 0

    for line in data
        l = strip(line)
        if length(l)>0
            this_cals += parse(Int64,l)
        else
            push!(elf_cals, this_cals)
            this_cals = 0
        end
    end
    push!(elf_cals, this_cals)
    top3 = sort(elf_cals)[end-2:end]
    return sum(top3)
end

function main()
    @assert part1(readlines(open("test1.txt"))) == 24000

    open("part1.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 1 is $(part1(data))")
    end

    @assert part2(readlines(open("test1.txt"))) == 45000

    open("part1.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 2 is $(part2(data))")
    end

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end