-- SubQueries
select *
from (
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 1
) as january_postings;

-- CTE
with january_postings as (
    select *
    from job_postings_fact
    where extract(month from job_posted_date)=1
 ) 
 select *
 from january_postings;

-- SubQueries in where
select  
        company_id,
        name as company_name
from 
        company_dim               
where 
        company_id in(
            select  
                company_id
            from 
                job_postings_fact
            where 
                job_no_degree_mention=TRUE
);

-- SubQueries & CTEs
with top_job_posting_companies as (
select 
        count(company_id) as job_postings_count,
        company_id
from    job_postings_fact
GROUP BY company_id  
)
select top_job_posting_companies.company_id, name as company_name,job_postings_count
from top_job_posting_companies
left join company_dim
on top_job_posting_companies.company_id = company_dim.company_id
order by job_postings_count desc;

