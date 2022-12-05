"""
"""

def part1(data):
    score = ?
    return score


def test_part1():
    data = open('test.txt').readlines()
    answer = ?
    result = part1(data)
    if not answer == result:
        raise AssertionError(f"Part1 FAIL: answer is {answer} not {result}")
    else:
        print("Part1 PASS")
    return True


def part2(data):
    score = ?
    return score

def test_part2():
    data = open('test.txt').readlines()
    answer = ?
    result = part2(data)
    if not answer == result:
        raise AssertionError(f"Part2 FAIL: answer is {answer} not {result}")
    else:
        print("Part2 PASS")
    return True


def main():
  if test_part1():
    data = open('input.txt').readlines()
    score = part1(data)
    print(f"Part 1 score is {score}")

  if test_part2():
    data = open('input.txt').readlines()
    score = part2(data)
    print(f"Part 2 score is {score}")
      
  return


if __name__ == "__main__":
  main()