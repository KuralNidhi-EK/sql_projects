create table job_applied (
    application_id INT,
    job_id INT,
    user_id INT,
    application_date DATE,
    status VARCHAR(50)
);

select * from job_applied;

insert INTO job_applied (application_id, job_id, user_id, application_date, status)
values (1, 101, 1001, '2024-06-01', 'Pending'), 
       (2, 102, 1002, '2024-06-02', 'Accepted'), 
       (3, 103, 1003, '2024-06-03', 'Rejected'), 
       (4, 104, 1004, '2024-06-04', 'Pending'), 
       (5, 105, 1005, '2024-06-05', 'Accepted');

alter table job_applied
add column remarks VARCHAR(255);      

update job_applied
set remarks = 'good job'
where status = 'Accepted';

alter TABLE job_applied
rename column remarks to feedback;

alter table job_applied
alter column feedback type text;

alter table job_applied
drop column feedback;

drop table job_applied;