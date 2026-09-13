# SQL Data Analysis Project

## Introduction

This project dives into the data analyst job market to uncover the highest-paying roles, the skills those roles demand, and which skills are worth learning first. Using real job posting data, I wrote a series of SQL queries to answer five key questions about salary and skill trends for **remote Data Analyst** positions.

📌 All SQL queries used in this analysis are in the [`project_sql`](./project_sql) folder.

## Background

Job hunting as a data analyst can feel overwhelming — countless postings, wildly different salaries, and endless lists of "required skills." This project was born from wanting a data-driven answer to a simple question: **which skills actually pay off?**

The data comes from a database of job postings that includes job titles, salaries, locations, and the specific skills tied to each posting via `job_postings_fact`, `company_dim`, `skills_job_dim`, and `skills_dim` tables.

The analysis set out to answer:

1. What are the top-paying Data Analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for Data Analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn (high demand **and** high pay)?

## Tools Used

To explore the data analyst job market, I used:

- **SQL** – the core tool for querying the database and answering every question in this project
- **PostgreSQL** – the database management system used to host and query the job postings data
- **Visual Studio Code** – for writing and running SQL scripts
- **Git & GitHub** – for version control and sharing this analysis

## Analysis

Each query in this project targeted a specific aspect of the data analyst job market. Here's how I approached each one.

### 1. Top-Paying Data Analyst Jobs

To find the highest-paying roles, I filtered Data Analyst positions by remote location (`Anywhere`) and non-null salaries, then sorted by average yearly salary. This also joins `company_dim` to surface the company behind each posting.

```sql
SELECT
        job_id,
        job_title,
        company_dim.name AS company_name,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date
FROM job_postings_fact
LEFT JOIN company_dim
    ON company_dim.company_id = job_postings_fact.company_id
WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

**Highlights:**
- Remote Data Analyst salaries in the top 10 show a wide range, reflecting how much seniority, industry, and company size affect pay.
- A mix of well-known and lesser-known companies appear in the top-paying list, showing that high salaries aren't limited to "big name" employers.

### 2. Skills for Top-Paying Data Analyst Jobs

Building on Query 1, I used a CTE to isolate the top 10 highest-paying jobs, then joined `skills_job_dim` and `skills_dim` to see exactly which skills those roles required.

```sql
WITH top_paying_jobs AS (
    SELECT
            job_id,
            job_title,
            company_dim.name AS company_name,
            salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim
        ON company_dim.company_id = job_postings_fact.company_id
    WHERE
            job_title_short = 'Data Analyst' AND
            job_location = 'Anywhere' AND
            salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT
        top_paying_jobs.*,
        skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim
    ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id;
```

**Highlights:**
- SQL and Python show up repeatedly across the highest-paying postings, reinforcing them as foundational skills.
- Tools like Tableau and Excel also appear, showing that visualization and reporting remain valued alongside technical querying skills.

### 3. In-Demand Skills for Data Analysts

To find the skills employers ask for most often — regardless of salary — I counted how many job postings mentioned each skill across all Data Analyst roles.

```sql
SELECT
        skills,
        COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
        job_title_short = 'Data Analyst'
GROUP BY
        skills
ORDER BY
        demand_count DESC
LIMIT 5;
```

**Highlights:**
- SQL and Excel lead in overall demand, confirming they're the baseline expectations for almost any Data Analyst role.
- Python and visualization tools (like Tableau) round out the top 5, showing a blend of querying, spreadsheet, and BI skills is expected.

### 4. Top Skills Based on Salary

Here I flipped the lens from "how often" to "how much" — calculating the average salary tied to each skill across all Data Analyst roles with a listed salary.

```sql
SELECT
        skills,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
GROUP BY
        skills
ORDER BY
        avg_salary DESC
LIMIT 15;
```

**Highlights:**
- Specialized and less common tools (big data platforms, cloud, and engineering-adjacent skills) tend to command the highest average salaries.
- This suggests that niche or advanced technical skills can significantly boost earning potential beyond the "standard" analyst toolkit.

### 5. Most Optimal Skills to Learn

Finally, I combined demand and salary into one query — filtering to remote roles with a listed salary, then requiring a skill to appear in more than 10 postings before ranking by average salary and demand.

```sql
SELECT
        skills_job_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary,
        COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True
GROUP BY
        skills_job_dim.skill_id,
        skills_dim.skills
HAVING
        COUNT(job_postings_fact.job_id) > 10
ORDER BY
        avg_salary DESC, demand_count DESC
LIMIT 25;
```

**Highlights:**
- The `HAVING count > 10` filter removes rare, one-off skills that could otherwise skew average salaries.
- The resulting list balances skills that are both realistically in demand and genuinely well-compensated — the sweet spot for prioritizing what to learn next.

## What I Learned

Working through this project strengthened several core SQL skills:

- 🧩 **Complex query building** – combining multiple `JOIN`s (`INNER` and `LEFT`) across four tables to connect job postings, companies, and skills.
- 📊 **Aggregation** – using `COUNT()` and `AVG()` alongside `GROUP BY` to summarize job market trends.
- 🧠 **CTEs (Common Table Expressions)** – breaking a complex question into a readable, reusable temporary result set with `WITH`.
- 🎯 **Filtering with `HAVING`** – applying conditions to aggregated results to remove statistical noise (like skills mentioned in only 1–2 postings).
- 🛠️ **Real-world problem framing** – translating a vague question ("what should I learn?") into a precise, answerable SQL query.

## Key Insights

- **SQL and Python are non-negotiable.** They appear consistently across both the highest-paying and most in-demand postings.
- **Demand and salary don't always overlap.** Some of the most frequently requested skills aren't the highest paid, and vice versa — which is exactly why Query 5 matters.
- **Remote roles pay a wide range.** The gap between the 1st and 10th highest-paying remote Data Analyst job is substantial, showing that "remote" doesn't mean standardized pay.
- **Niche and specialized skills carry a salary premium.** Skills that show up less often in postings tend to be tied to higher average salaries when they do appear.
- **The "optimal" skill list is a strategic shortcut.** Rather than chasing every skill in a job posting, Query 5's demand + salary combination gives a prioritized starting point for upskilling.

## Conclusion

This project turned a stack of raw job posting data into a clear, evidence-backed answer to "what should a Data Analyst learn next?" By progressing from top salaries → required skills → overall demand → salary by skill → the optimal overlap of both, the analysis builds a complete picture of the remote Data Analyst job market.

Beyond the specific findings, this project was a solid exercise in writing layered, real-world SQL — from simple filtered `SELECT`s to multi-table joins, CTEs, and aggregated `HAVING` conditions. It's a foundation I can build on for future data analysis work.