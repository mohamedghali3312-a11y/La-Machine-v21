import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.GCD.Basic
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Omega

-- 1. Symétrie miroir des résidus premiers avec V_k
theorem mirror_wheel_coprime_symmetry (V r : Nat) (h_le : r  P_m + Q_m = N := by
  intro C N Q_m P_m h_le
  dsimp only [C, N, Q_m, P_m]
  omega

-- 3. Récurrence exacte des maillons de Cunningham
theorem cunningham_link_formula (A m : Nat) :
    2 * (2 ^ (m + 1) * A + (2 ^ (m + 1) - 1)) + 1 = 2 ^ (m + 2) * A + (2 ^ (m + 2) - 1) := by
  have h1 : 1 <= 2 ^ (m + 1) := Nat.one_le_two_pow
  have h2 : 1 <= 2 ^ (m + 2) := Nat.one_le_two_pow
  zify [h1, h2]
  ring

-- 4. Obstruction modulaire de Cunningham au rang q - 2
theorem cunningham_modular_obstruction (A q : Nat) (hq_prime : Nat.Prime q) (hq_odd : q != 2) (h_div : q | A) :
    q | (2 ^ ((q - 2) + 1) * A + (2 ^ ((q - 2) + 1) - 1)) := by
  have hq_ge2 : 2 <= q := Nat.Prime.two_le hq_prime
  have h_exp : (q - 2) + 1 = q - 1 := by omega
  rw [h_exp]
  have h_coprime : Nat.Coprime 2 q := Nat.Prime.coprime_iff_not_dvd.mpr (by
    intro h2
    have := (Nat.Prime.eq_two_or_odd hq_prime).resolve_left (by simpa using hq_odd)
    omega)
  have h_fermat : 2 ^ (q - 1) ≡ 1 [MOD q] := Nat.ModEq.pow_card_sub_one_eq_one hq_prime h_coprime
  have h_dvd_rem : q | (2 ^ (q - 1) - 1) := (Nat.modEq_iff_dvd' Nat.one_le_two_pow).mp h_fermat.symm
  exact dvd_add (dvd_mul_of_dvd_right h_div (2 ^ (q - 1))) h_dvd_rem

-- 5. Structure de Proth / NTT généralisée au rang n : q_n - 1 = 2^n * K
theorem ntt_proth_structure (n K : Nat) :
    let q_n := 2 ^ n * K + 1
    q_n - 1 = 2 ^ n * K := by
  intro q_n
  dsimp only [q_n]
  omega
