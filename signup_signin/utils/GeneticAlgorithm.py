import random

def run_ga(questions, total_marks, difficulty_dist, population_size=30, generations=50):
    def fitness(individual):
        total = sum(q["Marks"] for q in individual)
        if total != total_marks:
            return 0
        diff_count = {"Easy": 0, "Medium": 0, "Hard": 0}
        for q in individual:
            diff_count[q["Difficulty"]] += 1
        percent = lambda c: (c / len(individual)) * 100
        score = 100 - sum(abs(percent(diff_count[d]) - difficulty_dist[d.lower()]) for d in diff_count)
        return score

    def mutate(individual, pool):
        idx = random.randint(0, len(individual) - 1)
        replacement = random.choice([q for q in pool if q not in individual])
        individual[idx] = replacement
        return individual

    def crossover(p1, p2):
        cut = random.randint(1, len(p1) - 2)
        return p1[:cut] + p2[cut:]

    pool = [{"id": q[0], "text": q[1], "Marks": q[2], "Difficulty": q[3], "Bloom": q[4]} for q in questions]

    def generate_individual():
        ind = []
        attempts = 0
        while sum(q["Marks"] for q in ind) < total_marks and attempts < 1000:
            q = random.choice(pool)
            if q not in ind:
                ind.append(q)
            attempts += 1
        return ind

    population = [generate_individual() for _ in range(population_size)]

    for _ in range(generations):
        population = sorted(population, key=fitness, reverse=True)
        next_gen = population[:5]
        while len(next_gen) < population_size:
            p1, p2 = random.sample(population[:10], 2)
            child = crossover(p1, p2)
            next_gen.append(mutate(child, pool))
        population = next_gen

    best = max(population, key=fitness)
    return best, fitness(best)
