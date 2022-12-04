"""
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
"""

SYMBOLS = 'rps'
RESULTS = 'ldw'

class throw():
    """
    Rules of rock paper scissors:
    rock beats scissors
    scissors beats paper
    paper beats rock
    """

    def __init__(self, rps):
        if rps.lower() not in SYMBOLS:
            raise AssertionError(f"rps must be one of {SYMBOLS}")
        self.choice = rps.lower()
    
    @property
    def value(self):
        return SYMBOLS.index(self.choice) + 1
    
    def __repr__(self):
        if self.choice=='r':
            return 'Rock'
        if self.choice =='s':
            return 'Scissors'
        if self.choice =='p':
            return 'Paper'

    def __eq__(self,other):
        return self.choice == other.choice
    
    def __lt__(self, other):
        if self.choice =='r':
            return other.choice == 'p'
        elif self.choice == 'p':
            return other.choice == 's'
        else:
            return other.choice == 'r'
            
    def __gt__(self, other):
        if self.choice =='r':
            return other.choice == 's'
        elif self.choice == 'p':
            return other.choice == 'r'
        else:
            return other.choice == 'p'

    def __add__(self,other):
        if not type(other)==type(1):
            raise TypeError(f"cannot add {type(other)} only {type(int)}")
        index = self.value-1 + other
        index = index % 3
        return throw(SYMBOLS[index])
    
    def __sub__(self,other):
        if not type(other)==type(1):
            raise TypeError(f"cannot add {type(other)} only {type(int)}")
        index = self.value-1 - other
        index = index % 3
        return throw(SYMBOLS[index])


def score_match(p1,p2):
    score = p2.value
    if p1==p2:
        score += 3
    elif p2>p1:
        score +=6
    else:
        pass
    return score


def part1(data):
    p1map = {'A':'r','B':'p','C':'s'}
    p2map = {'X':'r','Y':'p','Z':'s'}

    score = 0
    for d in data:
        if d.strip() =='':
            continue # skip empty lines (last)
        p1 = throw(p1map[d[0]])
        p2 = throw(p2map[d[2]])
        score += score_match(p1,p2)
    return score


def test_part1():
    data = open('test1.txt').readlines()
    answer = 15
    result = part1(data)
    if answer != result:
        raise AssertionError(f"Score should be {answer} not {result}")
    print("TEST: part1, PASS")
    return True


def choose_throw(p1, result):
    if result == 'd':
        return throw(p1.choice)
    elif result == 'w':
        return throw(p1.choice)+1
    else:
        return throw(p1.choice)-1


def part2(data):
    p1map = {'A':'r','B':'p','C':'s'}
    p2map = {'X':'l','Y':'d','Z':'w'}

    score = 0
    for d in data:
        if d.strip() =='':
            continue # skip empty lines (last)
        p1 = throw(p1map[d[0]])
        p2 = choose_throw(p1, p2map[d[2]])
        score += score_match(p1,p2)
    return score
    return 


def test_part2():
    data = open('test1.txt').readlines()
    answer = 12
    result = part2(data)
    if answer != result:
        raise AssertionError(f"Score should be {answer} not {result}")
    print("TEST: part2, PASS")
    return True


def main():
    if test_part1():
        data = open('input1.txt').readlines()
        score = part1(data)
        print(f"Part 1 score is {score}")
    
    if test_part2():
        data = open('input1.txt').readlines()
        score = part2(data)
        print(f"Part 2 score is {score}")
        
    return


if __name__ == "__main__":
    main()