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
# 7. Module Goldbach Paramétrique en m + Mesure du terme résiduel Hardy-Littlewood E_r(N)
def goldbach_parametric_analysis(N, S=3003):
    assert N >= 8 and N % 2 == 0
    while math.gcd(S, N) != 1 or math.gcd(S, N - 1) != 1:
        S //= math.gcd(S, N * (N - 1))
    valid_r = [r0 for r0 in range(S) if math.gcd(2 * r0 + 1, S) == 1 and math.gcd(N - (2 * r0 + 1), S) == 1]
    partitions = []
    half_N = N // 2
    for r0 in valid_r:
        Q_m = 2 * r0 + 1
        while Q_m <= half_N:
            P_m = N - Q_m
            if is_prime_deterministic(Q_m) and is_prime_deterministic(P_m):
                partitions.append((Q_m, P_m))
            Q_m += 2 * S

    PI_2 = 0.66016181584686957392
    singular_prod = 1.0
    temp, d = N, 3
    while d * d <= temp:
        if temp % d == 0:
            singular_prod *= (d - 1) / (d - 2)
            while temp % d == 0:
                temp //= d
        d += 2
    if temp > 2:
        singular_prod *= (temp - 1) / (temp - 2)
    G_HL = 2.0 * PI_2 * singular_prod * (N / (math.log(N) ** 2))
    G_reel = len(partitions)
    return {"N": N, "S": S, "G_reel": G_reel, "G_HL": round(G_HL, 2), "E_r": round(G_reel - G_HL, 2)}

# 8. Module Riemann : Calcul du ratio de Guy Robin R(n) sur les roues V_r et V_tilde_r
def robin_riemann_analysis(max_prime=37):
    primes = [p for p in range(2, max_prime + 1) if is_prime_deterministic(p)]
    V_r, V_tilde = 1, 1
    sigma_V, sigma_W = 1.0, 1.0
    for p in primes:
        V_r *= p
        sigma_V *= (1.0 + 1.0 / p)
        exp_p = int(math.log(max_prime) // math.log(p))
        V_tilde *= (p ** exp_p)
        sigma_W *= sum(p ** (-j) for j in range(exp_p + 1))
    e_gamma = math.exp(0.5772156649015328606)
    R_V = sigma_V / math.log(math.log(V_r))
    R_W = sigma_W / math.log(math.log(V_tilde))
    return {"p_r": max_prime, "R_V": round(R_V, 6), "R_W": round(R_W, 6), "Robin_ok": R_W < e_gamma}
    
# 9. Optimisation du socle primoriel S(N) sous la borne de Bombieri-Vinogradov
def optimal_bombieri_vinogradov_wheel(N, safety_exponent=2.0):
    assert N >= 100
    limit_S = math.sqrt(N) / (math.log(N) ** safety_exponent)
    small_primes = [3, 5, 7, 11, 13, 17, 19, 23, 29]
    S = 1
    used = []
    for p in small_primes:
        if S * p <= limit_S:
            S *= p
            used.append(p)
        else:
            break
    omega = 1
    for p in used:
        omega *= (p - 1) if (N % p == 0) else (p - 2)
    return {"N": N, "socle_optimal_S": S, "p_max": used[-1] if used else 1, "classes_admissibles": omega}

# 10. Entiers Colossalement Abondants (Ramanujan - Guy Robin)
def colossal_abundant_riemann_probe(epsilon_list=(0.15, 0.10, 0.07)):

    
    exp_gamma = math.exp(0.5772156649015328606)
    results = []
    for eps in epsilon_list:
        p_limit = int((1.0 + 1.0 / eps) ** (1.0 / (1.0 + eps))) + 2
        primes = [p for p in range(2, p_limit + 1) if is_prime_deterministic(p)]
        ln_N, abundance = 0.0, 1.0
        for p in primes:
            a_p = int(math.floor((math.log(p ** (1.0 + eps) - 1.0) - math.log(p ** eps - 1.0)) / math.log(p))) - 1
            if a_p >= 1:
                ln_N += a_p * math.log(p)
                abundance *= (1.0 - p ** (-(a_p + 1))) / (1.0 - 1.0 / p)
        ratio = abundance / math.log(ln_N)
        results.append({"epsilon": eps, "ratio_robin_R": round(ratio, 6), "marge_riemann": round(exp_gamma - ratio, 6)})
    return results
# 11. Reduction paresseuse K-RED (Lazy NTT) sur d couches
def simulate_lazy_kred_ntt(X, k, n, layers=4):
    p = k * (1 << n) + 1
    assert is_prime_deterministic(p)
    mask = (1 << n) - 1
    val = X
    for _ in range(layers):
        val = k * (val & mask) - (val >> n)
    final_mod_p = (val * pow(k, -layers, p)) % p
    assert final_mod_p == (X % p)
    return {"corps_p": p, "couches_ntt": layers, "resultat_certifie": final_mod_p}

# 12. Extension Quadratique F_{p^2} = F_p[u]/(u^2 - beta) par Multiplication de Karatsuba
def fp2_extension_arithmetic(k, n, elem_a=(12345, 67890), elem_b=(54321, 98765)):
    p = k * (1 << n) + 1
    assert is_prime_deterministic(p)
    beta = next(b for b in range(2, 100) if pow(b, (p - 1) // 2, p) == p - 1)
    def fp2_mul(x, y):
        a0, a1 = x[0] % p, x[1] % p
        b0, b1 = y[0] % p, y[1] % p
        m0, m1 = (a0 * b0) % p, (a1 * b1) % p
        m2 = ((a0 + a1) * (b0 + b1)) % p
        return ((m0 + beta * m1) % p, (m2 - m0 - m1) % p)
    prod = fp2_mul(elem_a, elem_b)
    return {"corps_base_p": p, "irreductible": f"u^2 - {beta}", "produit_karatsuba": prod}


if __name__ == "__main__":
    assert next_prime_target_mode(10**12) == 1000000000039
    assert next_prime_burst_mode(10**12) == 1000000000039
    assert is_prime_deterministic((1 << 8) * 13 + 1)
    assert is_prime_deterministic((1 << 12) * 3 + 1)
    assert is_prime_deterministic((1 << 27) * 15 + 1)
    assert certify_pocklington(3329, 1, [2, 13]) == 3
    assert certify_pocklington(12289, 1, [2, 3]) == 11
    assert goldbach_parametric_analysis(10000)["G_reel"] == 127
    assert robin_riemann_analysis(37)["Robin_ok"] is True

    assert certify_pocklington(2013265921, 1, [2, 3, 5]) == 31
    assert optimal_bombieri_vinogradov_wheel(10**15)["socle_optimal_S"] == 15015
    assert colossal_abundant_riemann_probe((0.01,))[0]["marge_riemann"] > 0
    assert simulate_lazy_kred_ntt(9876543210123, 15, 27, layers=4)["resultat_certifie"] == 9876543210123 % 2013265921
    assert fp2_extension_arithmetic(15, 27)["irreductible"] == "u^2 - 11"

    print("Tests unitaires v21.1 (Architecture Duale > 99,9999 %) valides.")
