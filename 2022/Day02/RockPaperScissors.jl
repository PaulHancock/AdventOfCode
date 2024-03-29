#=
The Elves begin to set up camp on the beach. To decide whose tent gets to be
closest to the snack storage, a giant Rock Paper Scissors tournament is already
in progress.

Rock Paper Scissors is a game between two players. Each game contains many
rounds; in each round, the players each simultaneously choose one of Rock,
Paper, or Scissors using a hand shape. Then, a winner for that round is
selected: Rock defeats Scissors, Scissors defeats Paper, and Paper defeats
Rock. If both players choose the same shape, the round instead ends in a draw.

Appreciative of your help yesterday, one Elf gives you an encrypted strategy
guide (your puzzle input) that they say will be sure to help you win. "The
first column is what your opponent is going to play: A for Rock, B for Paper,
and C for Scissors. The second column--" Suddenly, the Elf is called away to
help with someone's tent.

The second column, you reason, must be what you should play in response: X for
Rock, Y for Paper, and Z for Scissors. Winning every time would be suspicious,
so the responses must have been carefully chosen.

The winner of the whole tournament is the player with the highest score. Your
total score is the sum of your scores for each round. The score for a single
round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3
for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if
the round was a draw, and 6 if you won).

Since you can't be sure if the Elf is trying to help you or trick you, you
should calculate the score you would get if you were to follow the strategy
guide.

For example, suppose you were given the following strategy guide:

AY BX CZ This strategy guide predicts and recommends the following:

- In the first round, your opponent will choose Rock (A), and you should choose
Paper (Y). This ends in a win for you with a score of 8 (2 because you chose
Paper + 6 because you won).

- In the second round, your opponent will choose
Paper (B), and you should choose Rock (X). This ends in a loss for you with a
score of 1 (1 + 0).

- The third round is a draw with both players choosing
Scissors, giving you a score of 3 + 3 = 6. 

In this example, if you were to follow the strategy guide, you would get a
total score of 15 (8 + 1 + 6).

What would your total score be if everything goes exactly according to your
strategy guide?

--- Part Two ---

The Elf finishes helping with the tent and sneaks back over to you. "Anyway,
the second column says how the round needs to end: X means you need to lose, Y
means you need to end the round in a draw, and Z means you need to win. Good
luck!"

The total score is still calculated in the same way, but now you need to figure
out what shape to choose so the round ends as indicated. The example above now
goes like this:

- In the first round, your opponent will choose Rock (A), and you need the
  round
to end in a draw (Y), so you also choose Rock. This gives you a score of 1 + 3
= 4.

- In the second round, your opponent will choose Paper (B), and you choose
Rock so you lose (X) with a score of 1 + 0 = 1.

- In the third round, you will
defeat your opponent's Scissors with Rock for a score of 1 + 6 = 7. 

Now that you're correctly decrypting the ultra top secret strategy guide, you
would get a total score of 12.

Following the Elf's instructions for the second column, what would your total
score be if everything goes exactly according to your strategy guide?
=#

# we will use arithmetic modulo 3 on these symbols to determine wins
# a-b =  0, draw
# a-b = +1, b wins
# a-b = -1, a wins
symbols = Dict('r'=>0, 'p'=>1,'s'=>2)
# this is how to modify the symbol of a
# so that b will get the desired result
results = Dict('w'=>1, 'd'=>0, 'l'=>-1)

function scoreMatch(p1,p2)
    score = p2+1
    if p1 == p2
        score += 3
    elseif mod(p2-p1,3) == 1
        score += 6
    end
    return score
end

function part1(data)
    p1map = Dict('A'=>symbols['r'],
                 'B'=>symbols['p'],
                 'C'=>symbols['s'])
    p2map = Dict('X'=>symbols['r'],
                 'Y'=>symbols['p'],
                 'Z'=>symbols['s'])
    score = 0
    for line in data
        l = strip(line)
        if length(l) == 0
            continue
        end
        p1 = p1map[l[1]]
        p2 = p2map[l[3]]
        score += scoreMatch(p1,p2)
    end
    return score
end

function part2(data)
    p1map = Dict('A'=>symbols['r'],
                 'B'=>symbols['p'],
                 'C'=>symbols['s'])
    p2map = Dict('X'=>results['l'],
                 'Y'=>results['d'],
                 'Z'=>results['w'])
    score = 0
    for line in data
        l = strip(line)
        if length(l) == 0
            continue
        end
        p1 = p1map[l[1]]
        p2 = mod(p1 + p2map[l[3]],3)
        score += scoreMatch(p1,p2)
    end
    return score
end

function main()
    @assert part1(readlines(open("test1.txt"))) == 15

    open("input1.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 1 is $(part1(data))")
    end

    @assert part2(readlines(open("test1.txt"))) == 12

    open("input1.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 2 is $(part2(data))")
    end

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end