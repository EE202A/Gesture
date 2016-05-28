from ranging import get_score


for i in range(8):
    score = get_score(0, i)
    if score[0] != -1:
        print score, i