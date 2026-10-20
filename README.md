#  HR Analytics SQL — 27 KPI RH complets

> **Analyse SQL approfondie des Ressources Humaines** · 27 requêtes couvrant turnover, absentéisme, performance, rémunération et promotion · Idéal pour piloter la fonction RH avec de la data.

![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![HR Analytics](https://img.shields.io/badge/HR_Analytics-FF6F00?style=for-the-badge)

---

##  Contexte

Projet d'analyse RH d'une entreprise fictive — démonstration de l'étendue possible de **SQL analytique** pour piloter la fonction RH : turnover, absentéisme, performance, rémunération, cohortes d'embauche.

**Objectif** : fournir aux RH et à la direction des **indicateurs actionnables** pour :
- Détecter précocement les signaux de turnover
- Comparer les rémunérations par ancienneté / département
- Analyser l'impact des promotions sur la rétention
- Suivre les cohortes d'embauche dans le temps

---

##  Modèle de données

**Schéma** : 5 tables principales couvrant les dimensions RH classiques

```
employes
├─ id_employe
├─ nom · prenom · genre · date_naissance
├─ date_embauche · date_sortie
├─ id_departement · id_manager
└─ niveau_poste · statut

departements
├─ id_departement
├─ nom_departement
└─ budget_annuel

historique_salaires
├─ id_salaire · id_employe
├─ date_effet · montant
└─ raison_changement

absences
├─ id_absence · id_employe
├─ date_debut · date_fin
└─ type_absence

evaluations_performance
├─ id_evaluation · id_employe
├─ annee · note_globale
└─ commentaire
```

---

##  Les 27 requêtes SQL

Les requêtes sont organisées en **5 thématiques** :

###  1. Turnover & Rétention (6 requêtes)
- Taux de turnover annuel
- Turnover par département
- Durée moyenne dans l'entreprise
- Analyse par cohortes d'embauche
- Détection des signaux faibles de départ
- Top 10 des départements les plus volatiles

###  2. Absentéisme (5 requêtes)
- Taux d'absentéisme global
- Jours moyens absents par employé
- Pics saisonniers d'absence
- Absences par type (maladie, congé, formation)
- Corrélation absence / performance

###  3. Performance (6 requêtes)
- Note moyenne par département
- Évolution de la note par employé (LAG)
- Top 10 performers
- Low performers à risque de départ
- Impact des évaluations sur promotion
- Comparaison performance manager vs équipe

### 💰 4. Rémunération (5 requêtes)
- Grille salariale par département
- Écarts salariaux par genre / niveau
- Benchmark par ancienneté
- Évolution des rémunérations dans le temps
- Augmentation moyenne annuelle

###  5. Promotion & Carrière (5 requêtes)
- Taux de promotion par département
- Délai moyen avant promotion
- Impact promotion sur rétention
- Hiérarchie managériale (CTE récursive)
- Analyse cohortes manager vs IC

---

##  Techniques SQL utilisées

Ce projet mobilise des **techniques SQL avancées** :

| Technique | Usage |
|---|---|
| **Window functions** | ROW_NUMBER, LAG, LEAD, SUM OVER, RANK |
| **CTE récursives** | Hiérarchie managériale multi-niveaux |
| **PIVOT / UNPIVOT** | Tableaux croisés RH |
| **GROUP BY avancé** | ROLLUP, CUBE, GROUPING SETS |
| **Date arithmetic** | AGE, EXTRACT, DATE_TRUNC |
| **Jointures complexes** | SELF JOIN, LATERAL JOIN |

---

##  Insights business identifiés

En exploitant ces 27 requêtes, 5 insights émergent :

1. **Détection précoce du turnover** — les employés avec 2 années consécutives de performance en baisse quittent 3× plus souvent
2. **Benchmark salarial** — écart de rémunération par ancienneté identifié dans 3 départements
3. **Impact promotion** — un employé promu dans ses 3 premières années reste en moyenne 2,8 ans de plus
4. **Cohortes d'embauche** — les cohortes recrutées en septembre-octobre ont le meilleur taux de rétention à 2 ans
5. **Corrélation absence-performance** — au-delà de 15 jours d'absence/an, la note de performance chute de 20 %

---

##  Structure du repo

```
hr-analytics-sql/
├── README.md
├── LICENSE
├── HR_Analytics_Script.sql       # Les 27 requêtes SQL
├── HR_Analytics.pdf              # Documentation complète
└── docs/
    └── (documentation complémentaire)
```

---

##  Comment utiliser le projet

### Pré-requis
- PostgreSQL 12+ (ou tout SGBD compatible SQL standard)
- Un IDE SQL : DBeaver, pgAdmin, DataGrip, VS Code...

### Installation

1. **Cloner le repo** :
```bash
git clone https://github.com/laurentdjiam/hr-analytics-sql.git
cd hr-analytics-sql
```

2. **Créer un schéma dédié** dans votre base PostgreSQL :
```sql
CREATE SCHEMA hr_analytics;
SET search_path = hr_analytics;
```

3. **Exécuter le script** :
```bash
psql -U votre_user -d votre_db -f HR_Analytics_Script.sql
```

4. **Explorer les 27 requêtes** une par une pour comprendre la logique métier RH

---

##  Usage pédagogique

Ce projet est conçu pour :
- **Étudiants Data** : cas pratique SQL analytique sur un cas métier concret
- **Analystes RH** : inspiration pour construire des indicateurs de pilotage
- **Formateurs** : support de cours SQL avancé (12-15h)
- **Recruteurs** : démonstration de compétences SQL complètes

**Compétences démontrées** :
- Maîtrise de SQL analytique (window functions, CTE récursives, PIVOT)
- Capacité à traduire un besoin métier RH en requêtes
- Rigueur de documentation et de versioning

---

##  Auteur

**Laurent NZWENJA DJIAM**
Data Analyst · Analytics Engineer · Consultant Power BI
3+ ans d'expérience · Ingénieur ECE Paris · MSc Data Engineer & IA

- 🔗 [LinkedIn](https://linkedin.com/in/laurent-nzwenja-djiam)
- 🌐 [Portfolio Notion](https://excited-reindeer-05e.notion.site)
- 💻 [GitHub](https://github.com/laurentdjiam)
- 📧 laurentdjiam@gmail.com

---

##  Licence

Projet open-source sous licence **MIT** — libre d'utilisation, modification, redistribution pour vos propres projets pédagogiques ou professionnels.

Voir [LICENSE](LICENSE) pour les détails complets.

---

##  Si ce projet vous est utile

** Star le repo** pour le partager avec la communauté Data francophone !

---

*Projet publié en octobre 2026 · Prochaine mise à jour : ajout d'exemples de visualisation Power BI à partir des requêtes.*
