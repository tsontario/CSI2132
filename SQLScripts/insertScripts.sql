-- INSERT inserts a job application of a specific user to a specific job
INSERT INTO applies_to VALUES (?, ?);

-- INSERT a new company into the database
INSERT INTO company (companysize, location, cname, password) VALUES
  (?, ?, ?, ?);

-- INSERT a new company review into the database
INSERT INTO company_review (username,companyid,interviewexperience,
                            onthejobexperience,salaryexperience,timestamp, companyrating)
VALUES (?, ?, ?, ?,
        ?, ?, ?);

-- INSERT a new job into the database
INSERT INTO job (joblevel, jobname, companyid, description,
                 numpositions, rateofpay, closingdate, postingdate)
VALUES (?, ?, ?, ?,
        ?, ?, ?, ?);

-- INSERT a new job to be approved by an admin
INSERT INTO job_approval (approved, jobid) VALUES
  (FALSE, ?);

-- INSERT a new relation row indicating a program is eligible for a job
INSERT INTO offered_to VALUES (?, ?);

-- INSERT a completed resume review to the database
INSERT INTO resume_review (resumeid, resumeversion, moderator, resumecomments)
VALUES (?, ?, ?, ?)
RETURNING reviewid;

-- INSERT a new user into the database
INSERT INTO suser VALUES
  (?, ?, ?, ?, ?, ?, ?);

-- INSERT make a user a moderator
INSERT INTO moderator(username) VALUES (?);

-- INSERT add a user as an administrator
INSERT INTO admin(username) VALUES (?);

-- INSERT a new resume review request
INSERT INTO resume_review_request(requesterid, resumeid, versionno) VALUES
  ('leule089', 2, 1);