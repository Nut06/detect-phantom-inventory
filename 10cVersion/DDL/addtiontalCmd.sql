-- drop all table and all CONSTRAINT
BEGIN
   FOR t IN (SELECT table_name FROM user_tables) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
   END LOOP;
END;
/

-- select all table
SELECT table_name FROM user_tables;

-- select all script can reuse when table was dropped
SELECT sequence_name, 
       min_value, 
       max_value, 
       increment_by, 
       last_number 
FROM user_sequences;

-- select all trigger can't reuse when table was dropped
SELECT trigger_name, 
       table_name, 
       trigger_type, 
       triggering_event, 
       status 
FROM user_triggers;