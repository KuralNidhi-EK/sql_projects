/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/

SELECT  
        skills_job_dim.skill_id,
        skills_dim.skills,
        round(AVG(salary_year_avg),0) as avg_salary,
        count(job_postings_fact.job_id) as demand_count
from    job_postings_fact
INNER JOIN  skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_dim.skill_id=skills_job_dim.skill_id
WHERE 
        job_title_short='Data Analyst' AND
        salary_year_avg is NOT NULL AND job_work_from_home = True
GROUP BY
        skills_job_dim.skill_id,
        skills_dim.skills
HAVING
        count(job_postings_fact.job_id) > 10
ORDER BY
        avg_salary DESC, demand_count DESC
limit 25;