-- Preuves formelles autonomes en Lean 4 pur (v21.1) — Mohamed Ghali                                                                                                                  
theorem mirrorWheelSym (V r : Nat) (h1 : r <= V) (h2 : Nat.gcd r V = 1) : Nat.gcd (V - r) V = 1 := by
  apply Nat.dvd_antisymm _ (Nat.one_dvd _)
  rw [← h2]
  exact Nat.dvd_gcd (by have ha := Nat.gcd_dvd_left (V - r) V; have hb := Nat.gcd_dvd_right (V - r) V; rw [Nat.dvd_iff_mod_eq_zero] at ha hb ⊢; omega) (Nat.gcd_dvd_right (V - r) V)

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
