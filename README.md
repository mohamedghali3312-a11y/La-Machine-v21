# LA MACHINE v23.0 — Primorial Wheel Arithmetic, Post-Quantum NTT Cryptography & Formal Certification in Lean 4

[![CI Lean 4 & Python](https://github.com)](https://github.com)
**Author / Auteur :** Mohamed Ghali ([ORCID: 0009-0006-3364-5341](https://orcid.org))  
**Latest Release :** [`v23.0`](https://github.com) (16 Lean 4 Theorems + 12 Python Modules + Full LaTeX/PDF Book)

---

## English Overview

**La Machine** is an algorithmic and formal verification framework dedicated to analytic number theory, lattice-based post-quantum cryptography (NTT / ZK-STARKs), and machine-checked proofs in **pure Lean 4** (zero external dependencies).

### Repository Contents
* **`la_machine_v21_proofs.lean`** — **16 complete mathematical theorems** formally verified by Lean 4 (`lake build`).
* **`la_machine_v21.py`** — **12 reproducible Python modules** with full unit-test certification and benchmarks.
* **`Livre_LaMachine_v22.tex`** — **Complete Book Manuscript** (Preface + 4 Chapters: Primorial Wheels & Burst Mode, Post-Quantum Cryptography NTT/K-RED/$\mathbb{F}_{p^2}$, Parametric Goldbach-Chen Reduction, and Riemann Hypothesis / Guy Robin's Criterion), automatically compiled to PDF via GitHub Actions.
* **`LaMachine_v21.tex`** — Core research paper in LaTeX.

---

## Présentation en Français

**La Machine** est une architecture algorithmique et formelle dédiée à la théorie analytique des nombres, à la cryptographie post-quantique sur treillis (NTT / ZK-STARKs) et aux preuves mécanisées en **Lean 4 pur** (sans dépendance externe).

### Contenu du Dépôt
* **`la_machine_v21_proofs.lean`** — **16 théorèmes mathématiques complets** vérifiés mécaniquement par Lean 4 (`lake build`).
* **`la_machine_v21.py`** — **12 modules Python reproductibles** accompagnés de leur suite complète de tests unitaires et benchmarks.
* **`Livre_LaMachine_v22.tex`** — **Ouvrage complet** (Préface + 4 chapitres : Roues Primorielles & Mode Rafale, Cryptographie Post-Quantique NTT/K-RED/$\mathbb{F}_{p^2}$, Réduction de Goldbach & Théorème de Chen, Critère de Riemann / Guy Robin), compilé automatiquement en PDF via GitHub Actions.
* **`LaMachine_v21.tex`** — Article scientifique de synthèse en LaTeX.

---

## 16 Certified Lean 4 Theorems / Les 16 Théorèmes Certifiés en Lean 4

1. `mirrorWheelSym` — Mirror symmetry of units modulo $S_r$ / Symétrie miroir des unités modulo le socle primoriel $S_r$.
2. `scaleTrunc` — Burst Mode scale truncation / Troncature d'échelle du Mode Rafale (`next_prime_burst_mode`).
3. `goldbachParamId` — Exact parametric identity $P_m + Q_m = N$ / Identité paramétrique exacte $P_m + Q_m = N$.
4. `goldbachCoprimeQ` — Coprimality preservation $\gcd(Q_m, S) = 1$ / Préservation de la coprimalité $\gcd(Q_m, S) = 1$.
5. `cunninghamModObstruction` — Modular obstruction of Cunningham chains / Obstruction modulaire des chaînes de Cunningham.
6. `robinWeightedWheelDiv` — Divisibility of weighted wheels $\widetilde{V}_r$ / Divisibilité des roues pondérées $\widetilde{V}_r$ (critère de Guy Robin).
7. `nttProthStructure` — Algebraic structure of Proth primes $p = k \cdot 2^n + 1$ / Structure algébrique des corps premiers de Proth.
8. `goldbachPairSymmetry` — Involutive symmetry of admissible Goldbach pairs / Symétrie involutive des couples admissibles $(Q, N - Q)$.
9. `chenFactorsCoprimeWheel` — Coprimality of Chen factors ($N = p + q_1 q_2$) with $S$ / Coprimalité individuelle des facteurs de Chen avec $S$.
10. `prothHalfExponent` — Proth half-exponent $(p-1)/2 = k \cdot 2^{n-1}$ / Demi-exposant de Proth $(p-1)/2 = k \cdot 2^{n-1}$.
11. `nttPrimitiveRootPower` — Exact multiplicative order $2^n$ of primitive NTT roots / Ordre exact $2^n$ des racines primitives NTT.
12. `prothFastReductionIdentity` — Division-free fast modular reduction / Réduction modulaire rapide sans division matérielle.
13. `prothKRedTwoLayers` — Two-layer multiplicative stability of lazy K-RED / Stabilité multiplicative sur 2 couches de la NTT paresseuse K-RED.
14. `nttButterflyExactInverse` — Exact algebraic inversion of the NTT butterfly / Inversion algébrique exacte du papillon NTT / INTT.
15. `fp2KaratsubaExact` — Karatsuba multiplication accuracy in $\mathbb{F}_{p^2} = \mathbb{F}_p[u]/(u^2 - \beta)$ / Multiplication rapide de Karatsuba dans $\mathbb{F}_{p^2}$.
16. `abundanceFactorStrictGrowth` — Strict geometric growth of the abundance factor / Croissance géométrique stricte d'abondance (Riemann / Guy Robin).

---

## Academic Citation / Citation Scientifique

> Ghali, M. (2026). *La Machine v23.0: Primorial Wheel Arithmetic, Post-Quantum NTT Cryptography & Formal Certification in Lean 4*. GitHub / Zenodo. ORCID: 0009-0006-3364-5341.
