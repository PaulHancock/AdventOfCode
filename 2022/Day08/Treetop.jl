#=
--- Day 8: Treetop Tree House ---
The expedition comes across a peculiar patch of tall trees all planted carefully in a grid. The Elves explain that a previous expedition planted these trees as a reforestation effort. Now, they're curious if this would be a good location for a tree house.

First, determine whether there is enough tree cover here to keep a tree house hidden. To do this, you need to count the number of trees that are visible from outside the grid when looking directly along a row or column.

The Elves have already launched a quadcopter to generate a map with the height of each tree (your puzzle input). For example:

30373
25512
65332
33549
35390
Each tree is represented as a single digit whose value is its height, where 0 is the shortest and 9 is the tallest.

A tree is visible if all of the other trees between it and an edge of the grid are shorter than it. Only consider trees in the same row or column; that is, only look up, down, left, or right from any given tree.

All of the trees around the edge of the grid are visible - since they are already on the edge, there are no trees to block the view. In this example, that only leaves the interior nine trees to consider:

The top-left 5 is visible from the left and top. (It isn't visible from the right or bottom since other trees of height 5 are in the way.)
The top-middle 5 is visible from the top and right.
The top-right 1 is not visible from any direction; for it to be visible, there would need to only be trees of height 0 between it and an edge.
The left-middle 5 is visible, but only from the right.
The center 3 is not visible from any direction; for it to be visible, there would need to be only trees of at most height 2 between it and an edge.
The right-middle 3 is visible from the right.
In the bottom row, the middle 5 is visible, but the 3 and 4 are not.
With 16 trees visible on the edge and another 5 visible in the interior, a total of 21 trees are visible in this arrangement.

Consider your map; how many trees are visible from outside the grid?

--- Part Two ---
Content with the amount of tree cover available, the Elves just need to know the best spot to build their tree house: they would like to be able to see a lot of trees.

To measure the viewing distance from a given tree, look up, down, left, and right from that tree; stop if you reach an edge or at the first tree that is the same height or taller than the tree under consideration. (If a tree is right on the edge, at least one of its viewing distances will be zero.)

The Elves don't care about distant trees taller than those found by the rules above; the proposed tree house has large eaves to keep it dry, so they wouldn't be able to see higher than the tree house anyway.

In the example above, consider the middle 5 in the second row:

30373
25512
65332
33549
35390
Looking up, its view is not blocked; it can see 1 tree (of height 3).
Looking left, its view is blocked immediately; it can see only 1 tree (of height 5, right next to it).
Looking right, its view is not blocked; it can see 2 trees.
Looking down, its view is blocked eventually; it can see 2 trees (one of height 3, then the tree of height 5 that blocks its view).
A tree's scenic score is found by multiplying together its viewing distance in each of the four directions. For this tree, this is 4 (found by multiplying 1 * 1 * 2 * 2).

However, you can do even better: consider the tree of height 5 in the middle of the fourth row:

30373
25512
65332
33549
35390
Looking up, its view is blocked at 2 trees (by another tree with a height of 5).
Looking left, its view is not blocked; it can see 2 trees.
Looking down, its view is also not blocked; it can see 1 tree.
Looking right, its view is blocked at 2 trees (by a massive tree of height 9).
This tree's scenic score is 8 (2 * 2 * 1 * 2); this is the ideal spot for the tree house.

Consider each tree on your map. What is the highest scenic score possible for any tree?
=#


function is_visible(grid, i, j)
    # edges are always visible
    if (j == 1) | (i == 1) | (j == size(grid)[2]) | (i == size(grid)[1])
        return true
    end
    height = grid[i, j]

    #left
    vis = true
    for col in j-1:-1:1
        if grid[i, col] >= height
            vis = false
            break
        end
    end
    vis && return true

    #right
    vis = true
    for col in j+1:size(grid)[2]
        if grid[i, col] >= height
            vis = false
            break
        end
    end
    vis && return true

    #up
    vis = true
    for row in i-1:-1:1
        if grid[row, j] >= height
            vis = false
            break
        end
    end
    vis && return true

    #down
    vis = true
    for row in i+1:size(grid)[1]
        if grid[row, j] >= height
            vis = false
            break
        end
    end
    vis && return true
    return false
end


function part1(data)
    # load the data into a grid
    height = length(data)
    width = length(data[1])
    grid = Array{Int}(undef, height, width)
    for (i, line) in enumerate(data)
        for (j, char) in enumerate(strip(line))
            grid[i, j] = parse(Int, char)
        end
    end
    visible = similar(grid)

    for i in 1:width
        for j in 1:height
            # println(i, j, grid[i, j])
            visible[i, j] = is_visible(grid, i, j)
        end
    end
    return sum(visible)
end

function scenic_score(grid, i, j)
    height = grid[i, j]
    score = 1

    #left
    dist = 0
    for col in j-1:-1:1
        dist += 1
        if grid[i, col] >= height
            break
        end
    end
    score *= dist

    #right
    dist = 0
    for col in j+1:size(grid)[2]
        dist += 1
        if grid[i, col] >= height
            break
        end
    end
    score *= dist

    #up
    dist = 0
    for row in i-1:-1:1
        dist += 1
        if grid[row, j] >= height
            break
        end
    end
    score *= dist

    #down
    dist = 0
    for row in i+1:size(grid)[1]
        dist += 1
        if grid[row, j] >= height
            break
        end
    end
    score *= dist
    return score
end

function part2(data)
    # load the data into a grid
    height = length(data)
    width = length(data[1])
    grid = Array{Int}(undef, height, width)
    for (i, line) in enumerate(data)
        for (j, char) in enumerate(strip(line))
            grid[i, j] = parse(Int, char)
        end
    end
    scenic = similar(grid)

    for i in 1:width
        for j in 1:height
            scenic[i, j] = scenic_score(grid, i, j)
        end
    end
    return maximum(scenic)
end

function main()
    @assert part1(readlines(open("test.txt"))) == 21

    open("input.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 1 is $(part1(data))")
    end

    @assert part2(readlines(open("test.txt"))) == 8
    open("input.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 2 is $(part2(data))")
    end

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end