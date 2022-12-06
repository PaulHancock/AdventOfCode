

function part1(data)
    return false
end

function part2(data)
    return false
end

function main()
    @assert part1(readlines(open("test.txt"))) == ?

    open("input.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 1 is $(part1(data))")
    end

    @assert part2(readlines(open("test.txt"))) == 

    open("input.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 2 is $(part2(data))")
    end

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end