with remote_jobs as 
        (
        SELECT  
                job_postings_fact.job_id,
                CASE
                when job_postings_fact.job_location='Anywhere' then 'remote' 
                else 'not remote' end as job_location_type
        from    
                job_postings_fact
        )
select  
        skills_dim.skill_id, 
        skills as skill_name, 
        count(skills_job_dim.job_id) as job_count
from    
        skills_dim 
INNER join skills_job_dim
        on skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN remote_jobs
        on skills_job_dim.job_id = remote_jobs.job_id
where 
        job_location_type = 'remote'        
group by skills_dim.skill_id, skills
order by job_count desc
limit 5;
