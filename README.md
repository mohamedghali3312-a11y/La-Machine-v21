# LA MACHINE v23.0 — Arithmétique des Roues Primorielles, Cryptographie Post-Quantique & Certification Formelle en Lean 4

[![CI Lean 4 & Python](https://github.com)](https://github.com)
**Auteur :** Mohamed Ghali ([ORCID : 0009-0006-3364-5341](https://orcid.org))  
**Release actuelle :** [`v23.0`](https://github.com) (16 Théorèmes Lean 4 + 12 Modules Python + Ouvrage LaTeX/PDF)

---

## Vue d'ensemble du projet

**La Machine** est une architecture algorithmique et formelle dédiée à la théorie analytique des nombres, à la cryptographie post-quantique sur treillis (NTT) et aux preuves mécanisées en **Lean 4 pur** (sans dépendance externe).

### Contenu du dépôt
* **`la_machine_v21_proofs.lean`** : **16 théorèmes mathématiques complets** vérifiés mécaniquement par Lean 4 (`lake build`).
* **`la_machine_v21.py`** : **12 modules algorithmiques Python** reproductibles avec suite complète de tests unitaires et benchmarks.
* **`Livre_LaMachine_v22.tex`** : **Ouvrage complet** (Préface + 4 chapitres : Roues Primorielles & Mode Rafale, Cryptographie Post-Quantique NTT/K-RED/$\mathbb{F}_{p^2}$, Réduction de Goldbach & Théorème de Chen, Critère de Riemann / Guy Robin), compilé automatiquement en PDF via GitHub Actions.
* **`LaMachine_v21.tex`** : Article scientifique de synthèse au format LaTeX.

---

## Les 16 Théorèmes Formels Certifiés (`Lean 4`)

1. `mirrorWheelSym` — Symétrie miroir des unités modulo le socle primoriel $S_r$.
2. `scaleTrunc` — Troncature d'échelle du Mode Rafale (`next_prime_burst_mode`).
3. `goldbachParamId` — Identité paramétrique exacte $P_m + Q_m = N$.
4. `goldbachCoprimeQ` — Préservation de la coprimalité $\gcd(Q_m, S) = 1$ le long des progressions.
5. `cunninghamModObstruction` — Obstruction modulaire des chaînes de Cunningham.
6. `robinWeightedWheelDiv` — Divisibilité des roues pondérées $\widetilde{V}_r$ pour le critère de Guy Robin.
7. `nttProthStructure` — Structure algébrique des corps premiers de Proth $p = k \cdot 2^n + 1$.
8. `goldbachPairSymmetry` — Symétrie involutive des couples admissibles $(Q, N - Q)$ modulo $S$.
9. `chenFactorsCoprimeWheel` — Coprimalité individuelle des facteurs de Chen ($N = p + q_1 q_2$) avec $S$.
10. `prothHalfExponent` — Demi-exposant de Proth $(p-1)/2 = k \cdot 2^{n-1}$.
11. `nttPrimitiveRootPower` — Ordre multiplicatif exact $2^n$ des racines primitives NTT.
12. `prothFastReductionIdentity` — Réduction modulaire rapide sans division matérielle.
13. `prothKRedTwoLayers` — Stabilité multiplicative sur deux couches de la réduction paresseuse K-RED.
14. `nttButterflyExactInverse` — Inversion algébrique exacte du papillon NTT / INTT.
15. `fp2KaratsubaExact` — Exactitude de la multiplication de Karatsuba dans $\mathbb{F}_{p^2} = \mathbb{F}_p[u]/(u^2 - \beta)$.
16. `abundanceFactorStrictGrowth` — Croissance géométrique stricte du facteur d'abondance (Riemann / Guy Robin).

---

## Citation

> Ghali, M. (2026). *La Machine v23.0 : Arithmétique des Roues Primorielles, Cryptographie Post-Quantique NTT et Certification Formelle en Lean 4*. GitHub / Zenodo. ORCID : 0009-0006-3364-5341.
