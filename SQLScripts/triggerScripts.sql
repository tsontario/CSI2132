-- CREATE TRIGGER which queues notifications of new jobs for users of a given level
create function "Proj".function_job_notification() returns trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.approved = TRUE
  THEN
    INSERT INTO "Proj".job_notification
      (SELECT DISTINCT jobid, username
       FROM "Proj".suser INNER JOIN "Proj".job ON "Proj".suser.level = "Proj".job.joblevel NATURAL JOIN "Proj".job_approval
       WHERE jobid = NEW.jobid AND "Proj".job_approval.approved = TRUE);
    RETURN NEW;
  END IF;
  RETURN NEW;
END
$$;

CREATE TRIGGER trigger_notify_new_job
AFTER UPDATE ON "Proj".job_approval
FOR ROW
EXECUTE PROCEDURE "Proj".function_job_notification();

-- TRIGGER Populates the job_pending_approval table with the cross product of the new jobid and all admins
-- Strategy: When an admin receives a notification after logging on, the notificaitons for that
-- specific jobid are destroyed (so admins don't end up with 'stale' notifications).
CREATE FUNCTION "Proj".alert_admin_new_job() RETURNS TRIGGER AS
$BODY$
BEGIN
  IF NEW.approved = FALSE THEN
    INSERT INTO "Proj".job_pending_approval (
      SELECT DISTINCT jobid, username FROM "Proj".admin CROSS JOIN "Proj".job_approval WHERE jobid = NEW.jobid);
  END IF;
  RETURN NULL;
END;
$BODY$ LANGUAGE PLPGSQL;

CREATE TRIGGER alert_admin_new_job_trigger AFTER
INSERT ON "Proj".job_approval
FOR ROW
EXECUTE PROCEDURE "Proj".alert_admin_new_job();

-- TRIGGER This is the second part of the above trigger. It allows the removal of
-- redundant notifications. It is assumed only one admin needs to be notified of this information
CREATE FUNCTION "Proj".remove_redundant_pending_job_alerts() RETURNS TRIGGER AS
$BODY$
BEGIN
  DELETE FROM "Proj".job_pending_approval WHERE "Proj".job_pending_approval.jobid = OLD.jobid;
  RETURN NULL;
END;

$BODY$ LANGUAGE PLPGSQL;

CREATE TRIGGER remove_redundant_pending_job_alerts_trigger AFTER
DELETE ON "Proj".job_pending_approval
FOR ROW
EXECUTE PROCEDURE "Proj".remove_redundant_pending_job_alerts();

-- TRIGGER Alert moderators of new resume review requests
CREATE FUNCTION "Proj".alert_mod_new_resume_review_req() RETURNS TRIGGER AS
$BODY$
BEGIN
  INSERT INTO "Proj".new_resume_review_requests (
    SELECT resumeid, versionno, username FROM
      "Proj".moderator CROSS JOIN "Proj".resume_review_request
    WHERE "Proj".resume_review_request.resumeid = NEW.resumeid AND
          "Proj".resume_review_request.versionno = NEW.versionno);
  RETURN NULL;
END;
$BODY$ LANGUAGE PLPGSQL;

CREATE TRIGGER alert_mod_new_resume_review_req_trigger AFTER
INSERT ON "Proj".resume_review_request
FOR ROW
EXECUTE PROCEDURE "Proj".alert_mod_new_resume_review_req();

-- TRIGGER removing redundant notifications for resume review request
-- same reasoning as for admin notifications
CREATE FUNCTION "Proj".remove_redundant_resume_review_reqs() RETURNS TRIGGER AS
$BODY$
BEGIN
  DELETE FROM "Proj".new_resume_review_requests
  WHERE "Proj".new_resume_review_requests.resumeid = OLD.resumeid AND
        "Proj".new_resume_review_requests.versionno = OLD.versionno;
  RETURN NULL;
END;

$BODY$ LANGUAGE PLPGSQL;

CREATE TRIGGER remove_redundant_resume_review_reqs_trigger AFTER
DELETE ON "Proj".new_resume_review_requests
FOR ROW
EXECUTE PROCEDURE "Proj".remove_redundant_resume_review_reqs();

-- When a new job is created, it is automatically added to the job_approval table
-- to be accepted or rejected by an admin
CREATE OR REPLACE FUNCTION "Proj".new_job_pending_approval() RETURNS TRIGGER AS
$BODY$
BEGIN
  INSERT INTO "Proj".job_approval(jobid) VALUES (NEW.jobid);
  RETURN NULL;
END;
$BODY$ LANGUAGE PLPGSQL;


CREATE TRIGGER new_job_pending_approval_trigger
AFTER INSERT ON "Proj".job
FOR ROW
EXECUTE PROCEDURE new_job_pending_approval();


