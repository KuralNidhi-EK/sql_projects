create table january_job_postings as
    select *
    from job_postings_fact
    where extract(month from job_posted_date)=1;

select *
from january_job_postings
limit 10;
