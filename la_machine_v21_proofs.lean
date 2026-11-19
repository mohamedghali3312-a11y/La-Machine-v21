-- Preuves formelles autonomes en Lean 4 pur (v21.1) — Mohamed Ghali                                                                                                                  
theorem mirrorWheelSym (V r : Nat) (h1 : r <= V) (h2 : Nat.gcd r V = 1) : Nat.gcd (V - r) V = 1 := by
  apply Nat.dvd_antisymm _ (Nat.one_dvd _)
  rw [← h2]
  apply Nat.dvd_gcd _ (Nat.gcd_dvd_right (V - r) V)
  rcases Nat.gcd_dvd_left (V - r) V with ⟨k1, hk1⟩
  rcases Nat.gcd_dvd_right (V - r) V with ⟨k2, hk2⟩
  refine ⟨k2 - k1, ?_⟩
  rw [Nat.mul_sub_left_distrib]
  omega

  

theorem goldbachParamId (S K r m : Nat) (h : m <= K) : (2 * S * (K - m) + 1) + (2 * (r + m * S) + 1) = 2 * (K * S + r) + 2 := by
  have h1 : 2 * S * (K - m) + 2 * (m * S) = 2 * (K * S) := by
    rw [Nat.mul_sub_left_distrib, Nat.mul_comm m S, ← Nat.mul_assoc 2 S m, Nat.sub_add_cancel (Nat.mul_le_mul_left (2 * S) h), Nat.mul_assoc, Nat.mul_comm S K]
  omega
-- 3. Récurrence exacte des maillons de Cunningham : 2 * p_m + 1 = p_{m+1}
theorem cunninghamLinkFormula (A m : Nat) :
    2 * (2 ^ (m + 1) * A + (2 ^ (m + 1) - 1)) + 1 = 2 ^ (m + 2) * A + (2 ^ (m + 2) - 1) := by
  have h1 : 1 <= 2 ^ (m + 1) := Nat.pow_pos (by omega : 0 < 2)
  have h2 : 2 ^ (m + 2) = 2 * 2 ^ (m + 1) := by
    rw [Nat.pow_succ]
    omega
  have h3 : 2 ^ (m + 2) * A = 2 * (2 ^ (m + 1) * A) := by
    rw [h2, Nat.mul_assoc]
  omega

-- 4. Obstruction modulaire de Cunningham au rang q - 2
theorem cunninghamModularObstruction (A q : Nat) (hq : 2 <= q)
    (h_div_A : q ∣ A) (h_fermat : q ∣ (2 ^ (q - 1) - 1)) :
    q ∣ (2 ^ ((q - 2) + 1) * A + (2 ^ ((q - 2) + 1) - 1)) := by
  have h_exp : (q - 2) + 1 = q - 1 := by omega
  rw [h_exp]
  rcases h_div_A with ⟨k1, hk1⟩
  rcases h_fermat with ⟨k2, hk2⟩
  refine ⟨2 ^ (q - 1) * k1 + k2, ?_⟩
  rw [hk1, hk2, Nat.mul_add, Nat.mul_left_comm]

-- 5. Structure de Proth / NTT généralisée au rang n : q_n - 1 = 2^n * K
theorem nttProthStructure (n K : Nat) :
    let q_n := 2 ^ n * K + 1
    q_n - 1 = 2 ^ n * K := by
  intro q_n
  dsimp only [q_n]
  omega

-- 6. Invariance de la coprimalité de Q_m avec le socle S (Goldbach)
theorem goldbachCoprimeQ (S r m : Nat) (h : Nat.gcd (2 * r + 1) S = 1) :
    Nat.gcd (2 * (r + m * S) + 1) S = 1 := by
  apply Nat.dvd_antisymm _ (Nat.one_dvd _)
  rw [<- h]
  apply Nat.dvd_gcd _ (Nat.gcd_dvd_right (2 * (r + m * S) + 1) S)
  rcases Nat.gcd_dvd_left (2 * (r + m * S) + 1) S with ⟨k1, hk1⟩
  rcases Nat.gcd_dvd_right (2 * (r + m * S) + 1) S with ⟨k2, hk2⟩
  refine ⟨k1 - 2 * m * k2, ?_⟩
  rw [hk2, Nat.mul_sub_left_distrib, <- Nat.mul_assoc]
  omega

-- 7. Divisibilité exacte de la roue pondérée W par la roue primorielle V (Riemann / Robin)
theorem robinWeightedWheelDiv (V W p : Nat) (h_mul : Exists fun k => W = V * k)
    (hp : p ∣ V) : p ∣ W := by
  rcases h_mul with ⟨k1, hk1⟩
  rcases hp with ⟨k2, hk2⟩
  refine ⟨k2 * k1, ?_⟩
  rw [hk1, hk2, Nat.mul_assoc]


