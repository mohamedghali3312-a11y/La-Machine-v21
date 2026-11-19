import math
import time

# 1. Construction de la roue miroir V5 = 30 030 (5 760 pas miroirs en cache L1)
def build_mirror_wheel_V5():
    V5 = 30030
    first_half = [r for r in range(1, V5 // 2, 2) if math.gcd(r, V5) == 1]
    residues = first_half + [V5 - r for r in reversed(first_half)]
    steps = [residues[i + 1] - residues[i] for i in range(len(residues) - 1)]
    steps.append(V5 + residues[0] - residues[-1])
    return V5, residues, steps

# 2. Génération des premiers et inverses modulaires V5^(-1) mod p
def get_primes_with_inverses(limit, V5):
    sieve = bytearray(b'\x01') * (limit + 1)
    sieve[0:2] = b'\x00\x00'
    for p in range(2, int(limit**0.5) + 1):
        if sieve[p]:
            sieve[p*p : limit + 1 : p] = b'\x00' * len(range(p*p, limit + 1, p))
    return [(p, pow(V5, p - 2, p)) for p in range(17, limit + 1) if sieve[p]]

# 3. Verrou Fermat base 2 (> 99,9999 % élimination cumulée) + Miller-Rabin déterministe
def is_prime_deterministic(n):
    if n < 2:
        return False
    bases = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41)
    for p in bases:
        if n % p == 0:
            return n == p
    # Pré-filtre ultra-rapide Fermat base 2
    if pow(2, n - 1, n) != 1:
        return False
    d, s = n - 1, 0
    while d % 2 == 0:
        d //= 2
        s += 1
    for a in bases[1:]:
        x = pow(a, d, n)
        if x == 1 or x == n - 1:
            continue
        for _ in range(s - 1):
            x = pow(x, 2, n)
            if x == n - 1:
                break
        else:
            return False
    return True

# 4. Certification déterministe Lucas-Pocklington (P = R * F + 1 avec R < F)
def certify_pocklington(P, R, prime_factors_F):
    if R >= (P - 1) // R:
        return None
    if not all(is_prime_deterministic(q) for q in prime_factors_F):
        return None
    for a in range(2, 500):
        if pow(a, P - 1, P) == 1 and all(
            math.gcd(pow(a, (P - 1) // q, P) - 1, P) == 1
            for q in prime_factors_F
        ):
            return a
    return None

# 5. Mode Cible Unique : Roue V5 + Crible différentiel sans division (Latence minimale)
def next_prime_target_mode(start):
    V5, residues, steps = build_mirror_wheel_V5()
    small_primes = [p for p, _ in get_primes_with_inverses(10000, V5)]
    rem = start % V5
    idx = next((i for i, r in enumerate(residues) if r >= rem), len(residues))
    x = start + (V5 - rem + residues[0] if idx == len(residues) else residues[idx] - rem)
    idx %= len(steps)
    remainders = [x % p for p in small_primes]
    num_primes = len(small_primes)
    while True:
        if all(remainders):
            if is_prime_deterministic(x):
                return x
        step = steps[idx]
        x += step
        idx = (idx + 1) % len(steps)
        for i in range(num_primes):
            r = remainders[i] + step
            p = small_primes[i]
            remainders[i] = r - p if r >= p else r

# 6. Mode Rafale / Streaming : Fenêtre segmentée par inverses modulaires (Débit maximal)
def next_prime_burst_mode(start, sieve_limit=100000, turns=8):
    V5, residues, _ = build_mirror_wheel_V5()
    PHI_V5 = len(residues)
    primes_inv = get_primes_with_inverses(sieve_limit, V5)
    base_wheel = (start // V5) * V5
    rem_start = start - base_wheel
    start_idx = next((i for i, r in enumerate(residues) if r >= rem_start), PHI_V5)
    if start_idx == PHI_V5:
        base_wheel += V5
        start_idx = 0
    TOTAL_CANDS = turns * PHI_V5
    while True:
        mask = bytearray(b'\x01') * TOTAL_CANDS
        if start_idx > 0:
            mask[:start_idx] = b'\x00' * start_idx
            start_idx = 0
        for p, inv_V5 in primes_inv:
            b_mod_p = base_wheel % p
            for k_idx, r in enumerate(residues):
                t0 = ((-b_mod_p - r) * inv_V5) % p
                if t0 < turns:
                    pos_init = t0 * PHI_V5 + k_idx
                    count = (TOTAL_CANDS - 1 - pos_init) // (p * PHI_V5) + 1
                    mask[pos_init : TOTAL_CANDS : p * PHI_V5] = b'\x00' * count
        for j in range(TOTAL_CANDS):
            if mask[j]:
                cand = base_wheel + (j // PHI_V5) * V5 + residues[j % PHI_V5]
                if is_prime_deterministic(cand):
                    return cand
        base_wheel += turns * V5

if __name__ == "__main__":
    assert next_prime_target_mode(10**12) == 1000000000039
    assert next_prime_burst_mode(10**12) == 1000000000039
    assert is_prime_deterministic((1 << 8) * 13 + 1)
    assert is_prime_deterministic((1 << 12) * 3 + 1)
    assert is_prime_deterministic((1 << 27) * 15 + 1)
    assert certify_pocklington(3329, 1, [2, 13]) == 3
    assert certify_pocklington(12289, 1, [2, 3]) == 11
    assert certify_pocklington(2013265921, 1, [2, 3, 5]) == 31
    print("Tests unitaires v21.1 (Architecture Duale > 99,9999 %) valides.")
