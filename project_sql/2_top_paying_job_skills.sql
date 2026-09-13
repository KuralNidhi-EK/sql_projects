/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/

WITH top_paying_jobs as (
    select
            job_id,
            job_title,
            company_dim.name as company_name,
            salary_year_avg          
    from    job_postings_fact
    LEFT JOIN company_dim
    on company_dim.company_id=job_postings_fact.company_id
    where 
            job_title_short='Data Analyst' AND
            job_location='Anywhere' and 
            salary_year_avg is NOT NULL
    ORDER BY salary_year_avg DESC
    limit 10
)
select  top_paying_jobs.*,
        skills_dim.skills
from    top_paying_jobs
inner JOIN skills_job_dim
on skills_job_dim.job_id=top_paying_jobs.job_id
INNER JOIN skills_dim
ON skills_dim.skill_id=skills_job_dim.skill_id