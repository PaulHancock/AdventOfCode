

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

@assert part1(readlines(open("test1.txt"))) == 24000

open("part1.txt") do f
    # read till end of file
    data = readlines(f)
    println("Part 1 is $(part1(data))")
  end