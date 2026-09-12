select job_posted_date:: date 
FROM job_postings_fact
limit 10

select 
    '2023-02-19'::DATE,
    '123':: integer,
    'true':: boolean,
    '3.14':: real;

select
    job_title_short as title,
    job_location as location,
    job_posted_date as date
from job_postings_fact    
limit 10;

select
    job_title_short as title,
    job_location as location,
    job_posted_date::date as date
from job_postings_fact 
limit 10;

select job_posted_date at time zone 'UTC' at time zone 'EST'
from job_postings_fact
LIMIT 10;

select 
    job_posted_date at time zone 'UTC' at time zone 'EST' as est_date,
    extract(month from job_posted_date) as date_month
from job_postings_fact
limit 10;

SELECT
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    COUNT(job_id) AS monthly_job_count
FROM job_postings_fact
where job_title_short = 'Data Scientist'
GROUP BY date_month
order by monthly_job_count desc;