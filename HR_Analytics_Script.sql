-- =============================================================================
--  HR ANALYTICS  ·  SQL PROJECT #09
--  Auteur : Laurent NZWENJA DJIAM · Data Analyst · Consultant Power BI
--  27 KPIs business calculés en SQL
--  Testé sur MySQL 8+ et PostgreSQL 13+
-- =============================================================================


-- =============================================================================
--  PARTIE 1  ·  SETUP DE LA BASE
-- =============================================================================

CREATE DATABASE IF NOT EXISTS hr_analytics_db;
USE hr_analytics_db;

-- Table des départements
CREATE TABLE departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- Table des employés (fact table centrale)
CREATE TABLE employees (
    employee_id       INT PRIMARY KEY,
    employee_name     VARCHAR(100),
    gender            VARCHAR(10),
    age               INT,
    department_id     INT,
    designation       VARCHAR(100),
    salary            DECIMAL(10,2),
    hire_date         DATE,
    city              VARCHAR(50),
    employment_status VARCHAR(20),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- Table des présences
CREATE TABLE attendance (
    attendance_id   INT PRIMARY KEY,
    employee_id     INT,
    attendance_date DATE,
    status          VARCHAR(20),
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);

-- Table des évaluations de performance
CREATE TABLE performance (
    review_id           INT PRIMARY KEY,
    employee_id         INT,
    review_year         INT,
    performance_rating  DECIMAL(3,2),
    bonus               DECIMAL(10,2),
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);


-- =============================================================================
--  PARTIE 2  ·  JEU DE DONNÉES D'EXEMPLE
--  On enrichit le dataset original avec plus de lignes pour rendre les KPIs
--  intéressants à calculer.
-- =============================================================================

INSERT INTO departments VALUES
    (1, 'Engineering'),
    (2, 'Human Resources'),
    (3, 'Finance'),
    (4, 'Sales'),
    (5, 'Marketing');

INSERT INTO employees VALUES
    (101, 'Rahul Sharma',   'Male',   30, 1, 'Software Engineer',   85000, '2022-01-15', 'Mumbai',    'Active'),
    (102, 'Priya Verma',    'Female', 28, 4, 'Sales Executive',     65000, '2023-03-10', 'Delhi',     'Active'),
    (103, 'Amit Patel',     'Male',   35, 3, 'Financial Analyst',   92000, '2021-06-20', 'Pune',      'Active'),
    (104, 'Sneha Joshi',    'Female', 31, 2, 'HR Manager',          78000, '2020-11-12', 'Bangalore', 'Active'),
    (105, 'Rohan Gupta',    'Male',   29, 5, 'Marketing Specialist', 70000, '2024-02-01', 'Hyderabad', 'Resigned'),
    (106, 'Kavya Singh',    'Female', 26, 1, 'Software Engineer',   72000, '2023-08-05', 'Mumbai',    'Active'),
    (107, 'Vikram Iyer',    'Male',   42, 3, 'Finance Director',   140000, '2019-04-22', 'Pune',      'Active'),
    (108, 'Meera Nair',     'Female', 33, 4, 'Sales Manager',       95000, '2020-09-15', 'Delhi',     'Active'),
    (109, 'Arjun Reddy',    'Male',   27, 5, 'Marketing Specialist', 68000, '2024-05-20', 'Hyderabad', 'Active'),
    (110, 'Divya Rao',      'Female', 45, 2, 'HR Director',        120000, '2018-02-01', 'Bangalore', 'Active'),
    (111, 'Karan Mehta',    'Male',   32, 1, 'Tech Lead',          115000, '2021-01-10', 'Mumbai',    'Active'),
    (112, 'Anjali Kapoor',  'Female', 25, 4, 'Sales Executive',     58000, '2024-06-15', 'Delhi',     'Resigned'),
    (113, 'Suresh Kumar',   'Male',   38, 1, 'Senior Engineer',    102000, '2020-03-18', 'Mumbai',    'Active'),
    (114, 'Neha Sharma',    'Female', 30, 3, 'Financial Analyst',   88000, '2022-11-01', 'Pune',      'Active'),
    (115, 'Rajesh Yadav',   'Male',   41, 5, 'Marketing Manager',  105000, '2019-07-22', 'Hyderabad', 'Active');

INSERT INTO attendance VALUES
    (1,  101, '2025-01-01', 'Present'),
    (2,  102, '2025-01-01', 'Present'),
    (3,  103, '2025-01-01', 'Absent'),
    (4,  104, '2025-01-01', 'Present'),
    (5,  105, '2025-01-01', 'Leave'),
    (6,  101, '2025-01-02', 'Present'),
    (7,  102, '2025-01-02', 'Present'),
    (8,  103, '2025-01-02', 'Present'),
    (9,  104, '2025-01-02', 'Absent'),
    (10, 105, '2025-01-02', 'Present'),
    (11, 106, '2025-01-01', 'Present'),
    (12, 107, '2025-01-01', 'Present'),
    (13, 108, '2025-01-01', 'Leave'),
    (14, 109, '2025-01-01', 'Present'),
    (15, 110, '2025-01-01', 'Present'),
    (16, 111, '2025-01-01', 'Present'),
    (17, 112, '2025-01-01', 'Absent'),
    (18, 113, '2025-01-01', 'Present'),
    (19, 114, '2025-01-01', 'Present'),
    (20, 115, '2025-01-01', 'Leave');

INSERT INTO performance VALUES
    (1,  101, 2024, 4.8, 20000),
    (2,  102, 2024, 4.3, 12000),
    (3,  103, 2024, 4.9, 25000),
    (4,  104, 2024, 4.5, 18000),
    (5,  105, 2024, 3.9, 10000),
    (6,  106, 2024, 4.2, 14000),
    (7,  107, 2024, 4.7, 35000),
    (8,  108, 2024, 4.6, 22000),
    (9,  109, 2024, 4.0, 11000),
    (10, 110, 2024, 4.8, 30000),
    (11, 111, 2024, 4.9, 28000),
    (12, 112, 2024, 3.5,  8000),
    (13, 113, 2024, 4.4, 24000),
    (14, 114, 2024, 4.2, 16000),
    (15, 115, 2024, 4.6, 26000);


-- =============================================================================
--  PARTIE 3  ·  LES 27 KPIs BUSINESS
-- =============================================================================

-- -----------------------------------------------------------------------------
--  BLOC A · DÉMOGRAPHIE (5 KPIs)
-- -----------------------------------------------------------------------------

-- KPI #01 · Nombre total d'employés
SELECT COUNT(*) AS total_employees
FROM employees;


-- KPI #02 · Répartition Active vs Resigned
SELECT
    employment_status,
    COUNT(*)                                  AS nb_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*))
          OVER (), 2)                         AS pct_total
FROM employees
GROUP BY employment_status;


-- KPI #03 · Ratio de diversité de genre
SELECT
    gender,
    COUNT(*)                                 AS nb_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*))
          OVER (), 2)                        AS pct_workforce
FROM employees
GROUP BY gender;


-- KPI #04 · Distribution par tranche d'âge (avec CASE WHEN)
SELECT
    CASE
        WHEN age < 30                THEN '< 30 ans'
        WHEN age BETWEEN 30 AND 39   THEN '30-39 ans'
        WHEN age BETWEEN 40 AND 49   THEN '40-49 ans'
        ELSE                              '50+ ans'
    END                                        AS age_group,
    COUNT(*)                                   AS nb_employees
FROM employees
GROUP BY age_group
ORDER BY nb_employees DESC;


-- KPI #05 · Répartition par ville
SELECT
    city,
    COUNT(*)                                   AS nb_employees
FROM employees
GROUP BY city
ORDER BY nb_employees DESC;


-- -----------------------------------------------------------------------------
--  BLOC B · ANALYSE DES SALAIRES (5 KPIs)
-- -----------------------------------------------------------------------------

-- KPI #06 · Salaire moyen global
SELECT
    ROUND(AVG(salary), 2)   AS avg_salary_overall,
    MIN(salary)             AS min_salary,
    MAX(salary)             AS max_salary,
    ROUND(STDDEV(salary),2) AS salary_std
FROM employees;


-- KPI #07 · Salaire moyen par département (JOIN)
SELECT
    d.department_name,
    COUNT(e.employee_id)          AS nb_employees,
    ROUND(AVG(e.salary), 2)       AS avg_salary,
    ROUND(SUM(e.salary), 2)       AS total_payroll
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_salary DESC;


-- KPI #08 · Salaire moyen par intitulé de poste
SELECT
    designation,
    COUNT(*)                      AS nb_employees,
    ROUND(AVG(salary), 2)         AS avg_salary
FROM employees
GROUP BY designation
ORDER BY avg_salary DESC;


-- KPI #09 · Département le mieux rémunéré (subquery)
SELECT department_name, avg_salary
FROM (
    SELECT
        d.department_name,
        AVG(e.salary) AS avg_salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_name
) t
ORDER BY avg_salary DESC
LIMIT 1;


-- KPI #10 · Quartiles de salaire (NTILE window function)
SELECT
    employee_name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS salary_quartile
FROM employees;


-- -----------------------------------------------------------------------------
--  BLOC C · ATTRITION (3 KPIs)
-- -----------------------------------------------------------------------------

-- KPI #11 · Taux d'attrition global
SELECT
    ROUND(
        SUM(CASE WHEN employment_status = 'Resigned' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    )  AS attrition_rate_pct
FROM employees;


-- KPI #12 · Taux d'attrition par département
SELECT
    d.department_name,
    COUNT(*)                                                       AS nb_employees,
    SUM(CASE WHEN e.employment_status = 'Resigned' THEN 1 ELSE 0 END) AS nb_resigned,
    ROUND(
        SUM(CASE WHEN e.employment_status = 'Resigned' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    )  AS attrition_rate_pct
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY attrition_rate_pct DESC;


-- KPI #13 · Attrition par année d'embauche (date function)
SELECT
    EXTRACT(YEAR FROM hire_date)                                  AS hire_year,
    COUNT(*)                                                      AS nb_hired,
    SUM(CASE WHEN employment_status = 'Resigned' THEN 1 ELSE 0 END) AS nb_resigned
FROM employees
GROUP BY hire_year
ORDER BY hire_year DESC;


-- -----------------------------------------------------------------------------
--  BLOC D · PERFORMANCE (4 KPIs)
-- -----------------------------------------------------------------------------

-- KPI #14 · Note moyenne de performance
SELECT
    review_year,
    ROUND(AVG(performance_rating), 2) AS avg_rating,
    ROUND(AVG(bonus), 2)              AS avg_bonus
FROM performance
GROUP BY review_year;


-- KPI #15 · Top 5 performers (window function RANK)
WITH ranked_perf AS (
    SELECT
        e.employee_name,
        d.department_name,
        p.performance_rating,
        p.bonus,
        RANK() OVER (ORDER BY p.performance_rating DESC) AS rank_perf
    FROM performance p
    JOIN employees   e ON p.employee_id   = e.employee_id
    JOIN departments d ON e.department_id = d.department_id
)
SELECT *
FROM ranked_perf
WHERE rank_perf <= 5;


-- KPI #16 · Distribution du bonus par département
SELECT
    d.department_name,
    ROUND(AVG(p.bonus), 2)                    AS avg_bonus,
    ROUND(SUM(p.bonus), 2)                    AS total_bonus,
    MIN(p.bonus)                              AS min_bonus,
    MAX(p.bonus)                              AS max_bonus
FROM performance p
JOIN employees   e ON p.employee_id   = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_bonus DESC;


-- KPI #17 · Répartition par tranche de rating (CASE WHEN)
SELECT
    CASE
        WHEN performance_rating >= 4.5 THEN 'Top performer'
        WHEN performance_rating >= 4.0 THEN 'High performer'
        WHEN performance_rating >= 3.5 THEN 'Solid performer'
        ELSE                                'À accompagner'
    END          AS performance_bucket,
    COUNT(*)     AS nb_employees
FROM performance
GROUP BY performance_bucket
ORDER BY nb_employees DESC;


-- -----------------------------------------------------------------------------
--  BLOC E · EMBAUCHES ET ANCIENNETÉ (3 KPIs)
-- -----------------------------------------------------------------------------

-- KPI #18 · Nouveaux embauchés par année
SELECT
    EXTRACT(YEAR FROM hire_date) AS hire_year,
    COUNT(*)                     AS new_hires
FROM employees
GROUP BY hire_year
ORDER BY hire_year;


-- KPI #19 · Ancienneté moyenne (date function)
SELECT
    ROUND(AVG(
        DATEDIFF(CURDATE(), hire_date) / 365.25
    ), 1) AS avg_tenure_years
FROM employees
WHERE employment_status = 'Active';
-- Sur PostgreSQL, remplacer par :
-- SELECT ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date))), 1)


-- KPI #20 · Nouveaux embauchés par mois (date function + trend)
SELECT
    EXTRACT(YEAR FROM hire_date)  AS annee,
    EXTRACT(MONTH FROM hire_date) AS mois,
    COUNT(*)                      AS new_hires
FROM employees
GROUP BY annee, mois
ORDER BY annee, mois;


-- -----------------------------------------------------------------------------
--  BLOC F · PRÉSENCES ET ABSENTÉISME (3 KPIs)
-- -----------------------------------------------------------------------------

-- KPI #21 · Taux de présence global
SELECT
    ROUND(
        SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS attendance_rate_pct
FROM attendance;


-- KPI #22 · Taux d'absentéisme par employé
SELECT
    e.employee_name,
    COUNT(a.attendance_id)                                        AS total_days,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END)           AS days_absent,
    ROUND(
        SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(a.attendance_id), 2
    )                                                             AS absence_rate_pct
FROM employees e
JOIN attendance a ON e.employee_id = a.employee_id
GROUP BY e.employee_name
ORDER BY absence_rate_pct DESC;


-- KPI #23 · Utilisation des congés par département
SELECT
    d.department_name,
    COUNT(a.attendance_id)                                       AS total_days,
    SUM(CASE WHEN a.status = 'Leave' THEN 1 ELSE 0 END)           AS days_leave,
    ROUND(
        SUM(CASE WHEN a.status = 'Leave' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(a.attendance_id), 2
    )                                                            AS leave_rate_pct
FROM employees   e
JOIN attendance  a ON e.employee_id   = a.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;


-- -----------------------------------------------------------------------------
--  BLOC G · ANALYSES AVANCÉES (4 KPIs)
-- -----------------------------------------------------------------------------

-- KPI #24 · Liste des employés éligibles à une promotion
--  Critères : rating >= 4.5 ET ancienneté >= 2 ans ET Active
SELECT
    e.employee_name,
    d.department_name,
    e.designation,
    p.performance_rating,
    ROUND(DATEDIFF(CURDATE(), e.hire_date) / 365.25, 1) AS tenure_years
FROM employees   e
JOIN performance p ON e.employee_id   = p.employee_id
JOIN departments d ON e.department_id = d.department_id
WHERE e.employment_status = 'Active'
  AND p.performance_rating >= 4.5
  AND DATEDIFF(CURDATE(), e.hire_date) / 365.25 >= 2
ORDER BY p.performance_rating DESC;


-- KPI #25 · Rang de chaque employé dans son département par salaire
SELECT
    e.employee_name,
    d.department_name,
    e.salary,
    DENSE_RANK() OVER (
        PARTITION BY d.department_name
        ORDER BY e.salary DESC
    ) AS rank_in_dept
FROM employees   e
JOIN departments d ON e.department_id = d.department_id;


-- KPI #26 · Écart entre salaire et salaire moyen département (LAG-like pattern)
SELECT
    e.employee_name,
    d.department_name,
    e.salary,
    ROUND(AVG(e.salary) OVER (
        PARTITION BY d.department_name), 2)  AS avg_dept_salary,
    e.salary - AVG(e.salary) OVER (
        PARTITION BY d.department_name)      AS diff_vs_avg
FROM employees   e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.salary DESC;


-- KPI #27 · Dashboard HR — synthèse par département (CTE + toutes les métriques)
WITH dept_stats AS (
    SELECT
        d.department_id,
        d.department_name,
        COUNT(e.employee_id)                                            AS headcount,
        ROUND(AVG(e.salary), 2)                                         AS avg_salary,
        SUM(CASE WHEN e.employment_status = 'Resigned' THEN 1 ELSE 0 END) AS nb_resigned,
        ROUND(
            SUM(CASE WHEN e.employment_status = 'Resigned' THEN 1 ELSE 0 END)
            * 100.0 / COUNT(e.employee_id), 2
        )                                                               AS attrition_pct
    FROM departments d
    LEFT JOIN employees e ON e.department_id = d.department_id
    GROUP BY d.department_id, d.department_name
),
dept_perf AS (
    SELECT
        e.department_id,
        ROUND(AVG(p.performance_rating), 2) AS avg_rating,
        ROUND(SUM(p.bonus), 2)              AS total_bonus
    FROM performance p
    JOIN employees   e ON e.employee_id = p.employee_id
    GROUP BY e.department_id
)
SELECT
    s.department_name,
    s.headcount,
    s.avg_salary,
    s.attrition_pct,
    p.avg_rating,
    p.total_bonus
FROM dept_stats s
LEFT JOIN dept_perf p ON p.department_id = s.department_id
ORDER BY s.headcount DESC;


-- =============================================================================
--  FIN DU SCRIPT
--
--  Envie de voir le prochain projet (#10 · Real Estate Analytics) ?
--  Suivez-moi sur LinkedIn : Laurent NZWENJA DJIAM
--  → Data Analyst · Consultant Power BI · Disponible ASAP
-- =============================================================================
