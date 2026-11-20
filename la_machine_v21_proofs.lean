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
theorem goldbachCoprimeQ (S r m : Nat)
    (h : Nat.gcd (2 * r + 1) S = 1) :

     Nat.gcd (2 * (r + m * S) + 1) S = 1 := by
  
  apply Nat.dvd_antisymm _ (Nat.one_dvd _)
  suffices Dvd.dvd (Nat.gcd (2 * (r + m * S) + 1) S) (Nat.gcd (2 * r + 1) S) by rw [h] at this; exact this

  apply Nat.dvd_gcd _ (Nat.gcd_dvd_right _ _)

  let d := Nat.gcd (2 * (r + m * S) + 1) S
  rcases Nat.gcd_dvd_left (2 * (r + m * S) + 1) S with ⟨k1, hk1⟩
  rcases Nat.gcd_dvd_right (2 * (r + m * S) + 1) S with ⟨k2, hk2⟩
  refine ⟨k1 - 2 * m * k2, ?_⟩
  have h1 : 2 * (r + m * S) + 1 = d * k1 := hk1
  have h2 : S = d * k2 := hk2
  rw [Nat.mul_sub_left_distrib, <- Nat.mul_left_comm]
  rw [<- hk1, <- hk2]

  have h_lin : 2 * (r + m * S) + 1 = (2 * r + 1) + 2 * m * S := by
    rw [Nat.mul_add, Nat.mul_assoc, Nat.add_right_comm]
  rw [h_lin, Nat.add_sub_cancel]

-- 7. Divisibilité exacte de la roue pondérée W par la roue primorielle V (Riemann / Robin)
theorem robinWeightedWheelDiv (V W p : Nat) (h_mul : Exists fun k => W = V * k)
    (hp : p ∣ V) : p ∣ W := by
  rcases h_mul with ⟨k1, hk1⟩
  rcases hp with ⟨k2, hk2⟩
  refine ⟨k2 * k1, ?_⟩
  rw [hk1, hk2, Nat.mul_assoc]

-- 8. Symetrie involutive des couples admissibles de Goldbach modulo S
theorem goldbachPairSymmetry (N Q S : Nat) (hQ : Q <= N)
    (h_coprime : Nat.gcd Q S = 1 /\ Nat.gcd (N - Q) S = 1) :
    Nat.gcd (N - Q) S = 1 /\ Nat.gcd (N - (N - Q)) S = 1 := by
  have h_inv : N - (N - Q) = Q := Nat.sub_sub_self hQ
  rw [h_inv]
  exact ⟨h_coprime.2, h_coprime.1⟩

-- 9. Coprimalite individuelle des facteurs de Chen (Q_m = q1 * q2) avec S
theorem chenFactorsCoprimeWheel (q1 q2 S : Nat)
    (h_cop : Nat.gcd (q1 * q2) S = 1) :
    Nat.gcd q1 S = 1 /\ Nat.gcd q2 S = 1 := by
  refine ⟨?_, ?_⟩
  . apply Nat.dvd_antisymm _ (Nat.one_dvd _)
    suffices Dvd.dvd (Nat.gcd q1 S) (Nat.gcd (q1 * q2) S) by
      rw [h_cop] at this
      exact this
    exact Nat.dvd_gcd
      (Nat.dvd_trans (Nat.gcd_dvd_left q1 S) (Nat.dvd_mul_right q1 q2))
      (Nat.gcd_dvd_right q1 S)
  . apply Nat.dvd_antisymm _ (Nat.one_dvd _)
    suffices Dvd.dvd (Nat.gcd q2 S) (Nat.gcd (q1 * q2) S) by
      rw [h_cop] at this
      exact this
    exact Nat.dvd_gcd
      (Nat.dvd_trans (Nat.gcd_dvd_left q2 S) (Nat.dvd_mul_left q2 q1))
      (Nat.gcd_dvd_right q2 S)

-- 10. Structure algebrique du demi-exposant de Proth pour les corps finis NTT
theorem prothHalfExponent (p k n : Nat) (hn : 1 <= n)
    (h_proth : p = k * (2 ^ n) + 1) :
    (p - 1) / 2 = k * (2 ^ (n - 1)) := by
  have h1 : p - 1 = k * (2 ^ n) := by omega
  have h2 : 2 ^ n = 2 ^ (n - 1) * 2 := by rw [<- Nat.pow_succ]; congr 1; omega
 

  rw [h1, h2, <- Nat.mul_assoc, Nat.mul_div_cancel _ Nat.zero_lt_two]


-- 11. Identite d'ordre des racines primitives 2^n-iemes de l'unite pour la NTT
theorem nttPrimitiveRootPower (a k n : Nat) :
    (a ^ k) ^ (2 ^ (n - 1)) = a ^ (k * (2 ^ (n - 1))) := by
  rw [<- Nat.pow_mul]

-- 12. Identite algebrique de reduction rapide sans division pour p = k * 2^n + 1
theorem prothFastReductionIdentity (k n H L : Nat) :
    k * (H * (2 ^ n) + L) + H = H * (k * (2 ^ n) + 1) + k * L := by
  calc k * (H * (2 ^ n) + L) + H
      = k * (H * (2 ^ n)) + k * L + H := by rw [Nat.mul_add]
    _ = (k * H) * (2 ^ n) + H + k * L := by
        rw [<- Nat.mul_assoc, Nat.add_right_comm]
    _ = H * (k * (2 ^ n)) + H + k * L := by
        rw [Nat.mul_comm k H, Nat.mul_assoc]
    _ = H * (k * (2 ^ n) + 1) + k * L := by
        rw [Nat.mul_add, Nat.mul_one]
-- 13. Stabilite multiplicative de la reduction paresseuse K-RED sur deux couches
theorem prothKRedTwoLayers (k p X Y Z q1 q2 : Nat)
    (h1 : k * X = q1 * p + Y)
    (h2 : k * Y = q2 * p + Z) :
    (k * k) * X = (k * q1 + q2) * p + Z := by
  calc (k * k) * X
      = k * (k * X) := by rw [Nat.mul_assoc]
    _ = k * (q1 * p + Y) := by rw [h1]
    _ = k * (q1 * p) + k * Y := by rw [Nat.mul_add]
    _ = (k * q1) * p + (q2 * p + Z) := by rw [<- Nat.mul_assoc, h2]
    _ = ((k * q1) * p + q2 * p) + Z := by rw [Nat.add_assoc]
    _ = (k * q1 + q2) * p + Z := by rw [<- Nat.add_mul]

-- 14. Inversion algebrique exacte du papillon NTT (Cooley-Tukey -> Gentleman-Sande)
theorem nttButterflyExactInverse (U V w w_inv : Int)
    (h_inv : w * w_inv = 1) :
    let U' := U + w * V
    let V' := U - w * V
    (U' + V' = 2 * U) /\ ((U' - V') * w_inv = 2 * V) := by
  refine ⟨by omega, ?_⟩
  have h_diff : (U + w * V) - (U - w * V) = 2 * (w * V) := by omega
  rw [h_diff]
  calc (2 * (w * V)) * w_inv
      = 2 * ((w * w_inv) * V) := by
        rw [Int.mul_assoc 2, Int.mul_assoc w, Int.mul_comm V w_inv, <- Int.mul_assoc w]
    _ = 2 * (1 * V) := by rw [h_inv]
    _ = 2 * V := by rw [Int.one_mul]

-- 15. Exactitude de la multiplication de Karatsuba dans F_{p^2} = F_p[u]/(u^2 - beta)
theorem fp2KaratsubaExact (a0 a1 b0 b1 beta : Int) :
    let m0 := a0 * b0
    let m1 := a1 * b1
    let m2 := (a0 + a1) * (b0 + b1)
    (m0 + beta * m1 = a0 * b0 + beta * (a1 * b1)) /\
    (m2 - m0 - m1 = a0 * b1 + a1 * b0) := by
  refine ⟨rfl, ?_⟩
  have h_exp : (a0 + a1) * (b0 + b1) = a0 * b0 + a0 * b1 + a1 * b0 + a1 * b1 := by
    calc (a0 + a1) * (b0 + b1)
        = (a0 + a1) * b0 + (a0 + a1) * b1 := by rw [Int.mul_add]
      _ = (a0 * b0 + a1 * b0) + (a0 * b1 + a1 * b1) := by rw [Int.add_mul, Int.add_mul]
      _ = a0 * b0 + a0 * b1 + a1 * b0 + a1 * b1 := by omega
  omega
-- 16. Croissance stricte du facteur d'abondance geometrique (Riemann / Guy Robin)
theorem abundanceFactorStrictGrowth (p a : Nat) (hp : 2 <= p) :
    p ^ a * (p - 1) < p ^ (a + 1) - 1 := by
  
  have h_pa_pos : 1 <= p ^ a := by
    induction a with
    | zero => exact Nat.le_refl 1
    | succ k ih =>
      rw [Nat.pow_succ]
      calc 1 = 1 * 1 := rfl
        _ <= p ^ k * p := Nat.mul_le_mul ih (by omega)
  have h_pow : p ^ (a + 1) = p ^ a * p := Nat.pow_succ p a

  have h_mul : p ^ a * (p - 1) + p ^ a = p ^ a * p := by
    calc p ^ a * (p - 1) + p ^ a
        = p ^ a * (p - 1) + p ^ a * 1 := by rw [Nat.mul_one]
      _ = p ^ a * ((p - 1) + 1) := by rw [<- Nat.mul_add]
      _ = p ^ a * p := by
          have hp_sub : (p - 1) + 1 = p := Nat.sub_add_cancel (by omega)
          rw [hp_sub]
    rw [h_pow]
  omega



