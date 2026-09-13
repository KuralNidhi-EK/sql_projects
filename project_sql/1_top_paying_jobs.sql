/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely
- Focuses on job postings with specified salaries (remove nulls)
- BONUS: Include company names of top 10 roles
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
*/

select
        job_id,
        job_title,
        company_dim.name as company_name,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date
        
from job_postings_fact

LEFT JOIN company_dim
on company_dim.company_id=job_postings_fact.company_id

where 
        job_title_short='Data Analyst' AND
        job_location='Anywhere' and 
        salary_year_avg is NOT NULL

ORDER BY salary_year_avg DESC
limit 10;
