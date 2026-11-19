-- Preuves formelles autonomes en Lean 4 pur (v21.1) — Mohamed Ghali

-- 1. Symétrie miroir des résidus premiers avec V_k : si r | V et r | (V - r) alors r | V
theorem mirror_wheel_coprime_symmetry (V r : Nat) (h_le : r  P_m + Q_m = N := by
  intro C N Q_m P_m h_le
  dsimp only [C, N, Q_m, P_m]
  omega

-- 3. Récurrence exacte des maillons de Cunningham : 2 * p_m + 1 = p_{m+1}
theorem cunningham_link_formula (A m : Nat) :
    2 * (2 ^ (m + 1) * A + (2 ^ (m + 1) - 1)) + 1 = 2 ^ (m + 2) * A + (2 ^ (m + 2) - 1) := by
  have h1 : 1 <= 2 ^ (m + 1) := Nat.pow_pos (by omega : 0 < 2)
  have h2 : 2 ^ (m + 2) = 2 * 2 ^ (m + 1) := by
    rw [Nat.pow_succ]
    omega
  have h3 : 2 ^ (m + 2) * A = 2 * (2 ^ (m + 1) * A) := by
    rw [h2, Nat.mul_assoc]
  omega

-- 4. Obstruction modulaire de Cunningham au rang q - 2
theorem cunningham_modular_obstruction (A q : Nat) (hq : 2 <= q)
    (h_div_A : q ∣ A) (h_fermat : q ∣ (2 ^ (q - 1) - 1)) :
    q ∣ (2 ^ ((q - 2) + 1) * A + (2 ^ ((q - 2) + 1) - 1)) := by
  have h_exp : (q - 2) + 1 = q - 1 := by omega
  rw [h_exp]
  rcases h_div_A with ⟨k1, hk1⟩
  rcases h_fermat with ⟨k2, hk2⟩
  refine ⟨2 ^ (q - 1) * k1 + k2, ?_⟩
  rw [hk1, hk2]
  rw [Nat.mul_add, ← Nat.mul_assoc]

-- 5. Structure de Proth / NTT généralisée au rang n : q_n - 1 = 2^n * K
theorem ntt_proth_structure (n K : Nat) :
    let q_n := 2 ^ n * K + 1
    q_n - 1 = 2 ^ n * K := by
  intro q_n
  dsimp only [q_n]
  omega
