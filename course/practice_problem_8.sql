with first_quarter_jobs as (
SELECT * FROM jan_jobs
union ALL
SELECT * FROM feb_jobs
union ALL
SELECT * FROM mar_jobs
)
select * from first_quarter_jobs
where salary_year_avg> 70000;
