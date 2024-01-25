-- Drop tables
DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE staff CASCADE CONSTRAINTS;
DROP TABLE waiter CASCADE CONSTRAINTS;
DROP TABLE kitchenworker CASCADE CONSTRAINTS;
DROP TABLE receptionist CASCADE CONSTRAINTS;
DROP TABLE request CASCADE CONSTRAINTS;
DROP TABLE reservation CASCADE CONSTRAINTS;
DROP TABLE personaltable CASCADE CONSTRAINTS;
DROP TABLE viproom CASCADE CONSTRAINTS;

-- Drop sequences
DROP SEQUENCE customer_seq;
DROP SEQUENCE staff_seq;

-- Create sequences
-- Creating sequence for customer table
CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;

-- Creating sequence for staff table
CREATE SEQUENCE staff_seq START WITH 1 INCREMENT BY 1;

-- Create tables
-- Creating customer table
CREATE TABLE customer (
id_customer INTEGER DEFAULT customer_seq.NEXTVAL NOT NULL,
customer_name VARCHAR2(20) NOT NULL,
customer_phone VARCHAR2(20) NOT NULL CHECK (REGEXP_LIKE(customer_phone, '^\d{10}$')),
customer_address VARCHAR2(20) NOT NULL,
customer_email VARCHAR2(20) NOT NULL,
customer_type VARCHAR2(20) NOT NULL,
PRIMARY KEY (id_customer)
);

-- Creating staff table
CREATE TABLE staff (
id_staff INTEGER DEFAULT staff_seq.NEXTVAL NOT NULL,
staff_name VARCHAR2(50),
staff_phone VARCHAR2(20) NOT NULL CHECK (REGEXP_LIKE(staff_phone, '^\d{10}$')),
staff_email VARCHAR2(50),
staff_address VARCHAR2(100),
PRIMARY KEY (id_staff)
);

-- Realization of generalization/specialization relationship between staff and its subtypes (waiter, kitchenstaff, receptionist)
-- Creating waiter table
CREATE TABLE waiter (
id_staff INTEGER NOT NULL,
tips_received DECIMAL(10, 2),
FOREIGN KEY (id_staff) REFERENCES staff(id_staff),
PRIMARY KEY (id_staff)
);

-- Creating kitchenworker table
CREATE TABLE kitchenworker (
id_staff INTEGER NOT NULL,
experience_level VARCHAR2(20),
worker_type VARCHAR2(20),
FOREIGN KEY (id_staff) REFERENCES staff(id_staff),
PRIMARY KEY (id_staff)
);

-- Creating receptionist table
CREATE TABLE receptionist (
id_staff INTEGER NOT NULL,
phone_ext INTEGER,
FOREIGN KEY (id_staff) REFERENCES staff(id_staff),
PRIMARY KEY (id_staff)
);

-- Creating request table
CREATE TABLE request (
id_request INTEGER NOT NULL,
request_date DATE NOT NULL,
request_time TIMESTAMP WITH TIME ZONE NOT NULL,
request_price NUMBER(10, 2) NOT NULL,
request_status VARCHAR2(20) NOT NULL,
request_dishes varchar2(20) NOT NULL,
id_customer INTEGER NOT NULL,
id_staff INTEGER NOT NULL,
FOREIGN KEY (id_customer) REFERENCES customer(id_customer),
FOREIGN KEY (id_staff) REFERENCES staff(id_staff),
PRIMARY KEY (id_request)
);
-- Realization of generalization/specialization relationship between reservation and its subtypes (personaltable and viproom)
-- Creating reservation table
CREATE TABLE reservation(
id_reservation INTEGER NOT NULL,
reservation_date DATE NOT NULL,
reservation_time TIMESTAMP WITH TIME ZONE NOT NULL,
reservation_status VARCHAR2(20) NOT NULL,
reservation_capacity INTEGER NOT NULL,
id_customer INTEGER NOT NULL,
id_staff INTEGER NOT NULL,
FOREIGN KEY (id_customer) REFERENCES customer(id_customer),
FOREIGN KEY (id_staff) REFERENCES staff(id_staff),
PRIMARY KEY (id_reservation)
);

-- Creating personaltable table
CREATE TABLE personaltable(
id_reservation INTEGER NOT NULL,
table_number INTEGER NOT NULL,
FOREIGN KEY (id_reservation) REFERENCES reservation(id_reservation),
PRIMARY KEY (id_reservation)
);

-- Creating viproom table
CREATE TABLE viproom(
id_reservation INTEGER NOT NULL,
room_event VARCHAR2(20),
room_price NUMBER(10, 2) NOT NULL,
FOREIGN KEY (id_reservation) REFERENCES reservation(id_reservation),
PRIMARY KEY (id_reservation)
);

-- Insert data
-- Insert data into customer
insert into customer values (1, 'John', '1234567890', '123 Main St', 'john@gmail.com', 'regular');
insert into customer values (2, 'Jane', '0987654321', '456 Main St', 'jane@gmail.com', 'regular');
insert into customer values (3, 'Frank', '1234567899', '789 Main St', 'frank@gmail.com', 'regular');
insert into customer values (4, 'Alice', '1112223330', '321 Main St', 'alice@gmail.com', 'vip');
insert into customer values (5, 'Bob', '4445556660', '654 Main St', 'bob@gmail.com', 'vip');

-- Insert data into staff
insert into staff (staff_name, staff_phone, staff_email, staff_address) values ('John', '1235467890', 'john.staff@gmail.com', '123 Staff St');
insert into staff (staff_name, staff_phone, staff_email, staff_address) values ('Jane', '0987654321', 'jane.staff@gmail.com', '456 Staff St');
insert into staff (staff_name, staff_phone, staff_email, staff_address) values ('Frank', '1234567890', 'frank.staff@gmail.com', '789 Staff St');
insert into staff (staff_name, staff_phone, staff_email, staff_address) values ('Alice', '1112223330', 'alice.staff@gmail.com', '321 Staff St');
insert into staff (staff_name, staff_phone, staff_email, staff_address) values ('Bob', '4445556660', 'bob.staff@gmail.com', '654 Staff St');

-- Insert data into waiter
insert into waiter values (1, 10.00);
insert into waiter values (2, 15.50);
insert into waiter values (3, 20.00);
insert into waiter values (4, 12.30);
insert into waiter values (5, 7.50);

-- Insert data into kitchenworker
insert into kitchenworker values (1, 'Beginner', 'Cook');
insert into kitchenworker values (2, 'Intermediate', 'Chef');
insert into kitchenworker values (3, 'Advanced', 'Sous Chef');
insert into kitchenworker values (4, 'Expert', 'Head Chef');
insert into kitchenworker values (5, 'Beginner', 'Prep Cook');

-- Insert data into receptionist
insert into receptionist values (1, 101);
insert into receptionist values (2, 102);
insert into receptionist values (3, 103);
insert into receptionist values (4, 104);
insert into receptionist values (5, 105);

-- Insert data into request
insert into request (id_request, request_date, request_time, request_price, request_status, request_dishes, id_customer, id_staff) values (1, TO_DATE('2023-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-03-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 'Happened', 'Caesar salad',1, 1);
insert into request (id_request, request_date, request_time, request_price, request_status, request_dishes, id_customer, id_staff) values (2, TO_DATE('2023-04-12', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-04-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 20, 'Pending', 'French fries',2, 2);
insert into request (id_request, request_date, request_time, request_price, request_status, request_dishes, id_customer, id_staff) values (3, TO_DATE('2023-04-15', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-04-15 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 25, 'Pending', 'Onion soup',3, 3);
insert into request (id_request, request_date, request_time, request_price, request_status, request_dishes, id_customer, id_staff) values (4, TO_DATE('2023-04-20', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-04-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 15, 'Pending', 'Tomato soup',4, 4);
insert into request (id_request, request_date, request_time, request_price, request_status, request_dishes, id_customer, id_staff) values (5, TO_DATE('2023-04-25', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-04-25 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 13, 'Pending', 'Steak',5, 5);

-- Insert data into reservation
insert into reservation values (1, TO_DATE('2023-05-01', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-05-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Confirmed', 10,1, 1);
insert into reservation values (2, TO_DATE('2023-05-05', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-05-05 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Confirmed', 3,2, 2);
insert into reservation values (3, TO_DATE('2023-05-10', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-05-10 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Declined', 1,3, 3);
insert into reservation values (4, TO_DATE('2023-05-15', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-05-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Confirmed', 4,4, 4);
insert into reservation values (5, TO_DATE('2023-05-16', 'YYYY-MM-DD'), TO_TIMESTAMP_TZ('2023-05-16 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Confirmed', 2,5, 5);

-- Insert data into personaltable
insert into personaltable values (1, 1);
insert into personaltable values (2, 2);
insert into personaltable values (3, 3);
insert into personaltable values (4, 4);
insert into personaltable values (5, 5);

-- Insert data into viproom
insert into viproom values (1, 'Birthday Party', 100);
insert into viproom values (2, 'Anniversary', 150);
insert into viproom values (3, 'Corporate Event', 200);
insert into viproom values (4, 'Wedding Reception', 300);
insert into viproom values (5, 'Product Launch', 250);

-- Select queries
-- 1. Select all customers and their respective reservations (two-table join)
-- Purpose: Display all customers with their reservation details
SELECT c.customer_name, r.id_reservation, r.reservation_date, r.reservation_time, r.reservation_status
FROM customer c
JOIN reservation r ON c.id_customer = r.id_customer;

-- 2. Select all staff members and their corresponding waiter details (two-table join)
-- Purpose: Display all staff members who are waiters and their tip details
SELECT s.staff_name, w.tips_received
FROM staff s
JOIN waiter w ON s.id_staff = w.id_staff;

-- 3. Select all customers who have made requests, along with their request details and staff member responsible for the request (three-table join)
-- Purpose: Display all customers with their request details and the staff members responsible for handling their requests
SELECT c.customer_name, req.request_date, req.request_time, req.request_status, s.staff_name
FROM customer c
JOIN request req ON c.id_customer = req.id_customer
JOIN staff s ON req.id_staff = s.id_staff;

-- 4. Total request prices grouped by request status (GROUP BY with an aggregate function)
-- Purpose: Calculate the total prices of requests based on their status (e.g., pending or happened)
SELECT req.request_status, SUM(req.request_price) as total_price
FROM request req
GROUP BY req.request_status;

-- 5. Average tip received by waiters (GROUP BY with an aggregate function)
-- Purpose: Calculate the average tip received by waiters
SELECT AVG(w.tips_received) as average_tip
FROM waiter w;

-- 6. Select customers who have made a reservation for a VIP room (EXISTS predicate)
-- Purpose: Display all customers who have booked a VIP room
SELECT c.customer_name
FROM customer c
WHERE EXISTS (
SELECT 1
FROM reservation r
JOIN viproom v ON r.id_reservation = v.id_reservation
WHERE c.id_customer = r.id_customer
);

-- 7. Select all reservations made by customers who have made a request with a status of 'Pending' (IN predicate with a nested select)
-- Purpose: Display all reservations made by customers who have a pending request
SELECT r.*
FROM reservation r
WHERE r.id_customer IN (
SELECT req.id_customer
FROM request req
WHERE req.request_status = 'Pending'
);

-- 8. Select all kitchen workers and their corresponding staff details
-- Purpose: Display all staff members who are kitchen workers and their experience levels
SELECT s.staff_name, k.experience_level
FROM staff s
JOIN kitchenworker k ON s.id_staff = k.id_staff;


-- Drop trg_request_price_increase trigger if it exists
BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER trg_request_price_increase';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -4080 THEN
      RAISE;
    END IF;
END;
/

-- Drop trg_viproom_check_price trigger if it exists
BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER trg_viproom_check_price';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -4080 THEN
      RAISE;
    END IF;
END;
/

-- Drop procedures
DROP PROCEDURE list_pending_requests;
DROP PROCEDURE update_customer_type;


-- Trigger 1: Increase request price by 10% if the request is assigned to a VIP customer
CREATE OR REPLACE TRIGGER trg_request_price_increase
BEFORE INSERT OR UPDATE ON request
FOR EACH ROW
DECLARE
  customer_type VARCHAR2(20);
BEGIN
  SELECT c.customer_type
  INTO customer_type
  FROM customer c
  WHERE c.id_customer = :new.id_customer;
  IF customer_type = 'vip' THEN
    :new.request_price := :new.request_price * 1.1;
  END IF;
END;
/

-- Trigger 2: Check if the VIP room price is above the minimum allowed price
CREATE OR REPLACE TRIGGER trg_viproom_check_price
BEFORE INSERT OR UPDATE ON viproom
FOR EACH ROW
DECLARE
  min_price NUMBER := 50;
BEGIN
  IF :new.room_price < min_price THEN
    RAISE_APPLICATION_ERROR(-20001, 'The VIP room price must be greater than or equal to ' || min_price);
  END IF;
END;
/

-- Create procedures
-- Procedure 1: List all pending requests with customer and staff details
CREATE OR REPLACE PROCEDURE list_pending_requests
AS
  CURSOR c_pending_requests IS
    SELECT c.customer_name, req.request_date, req.request_time, req.request_status, s.staff_name
    FROM customer c
    JOIN request req ON c.id_customer = req.id_customer
    JOIN staff s ON req.id_staff = s.id_staff
    WHERE req.request_status = 'Pending';
  r_pending_requests c_pending_requests%ROWTYPE;
BEGIN
  OPEN c_pending_requests;
  LOOP
    FETCH c_pending_requests INTO r_pending_requests;
    EXIT WHEN c_pending_requests%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Customer: ' || r_pending_requests.customer_name || ', Request Date: ' || r_pending_requests.request_date || ', Request Time: ' || r_pending_requests.request_time || ', Staff: ' || r_pending_requests.staff_name);
  END LOOP;
  CLOSE c_pending_requests;
END;
/

-- Procedure 2: Update customer type based on the total amount spent on requests
CREATE OR REPLACE PROCEDURE update_customer_type(p_customer_id INTEGER)
AS
  v_total_spent NUMBER;
  v_new_customer_type customer.customer_type%TYPE;
BEGIN
  SELECT SUM(request_price)
  INTO v_total_spent
  FROM request
  WHERE id_customer = p_customer_id;

  IF v_total_spent >= 500 THEN
    v_new_customer_type := 'vip';
  ELSE
    v_new_customer_type := 'regular';
  END IF;

  UPDATE customer
  SET customer_type = v_new_customer_type
  WHERE id_customer = p_customer_id;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No customer found with ID ' || p_customer_id);
END;
/

-- Demonstrate stored procedures
-- Call list_pending_requests
BEGIN
  list_pending_requests;
END;
/

-- Call update_customer_type
BEGIN
  update_customer_type(1);
END;
/

-- Index creation
-- Index 1: Index on customer.customer_type to speed up the check for VIP customers in the trg_request_price_increase trigger
CREATE INDEX idx_customer_type ON customer(customer_type);

-- EXPLAIN PLAN demonstration
-- Get the execution plan for Query 4(at least two tables and use aggregation functions and GROUP BY clauses)
EXPLAIN PLAN FOR
SELECT req.request_status, SUM(req.request_price) as total_price
FROM request req
GROUP BY req.request_status;

-- Display the execution plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Create an index to optimize Query 4
CREATE INDEX idx_request_status ON request(request_status);

-- Get the execution plan for Query 4 after creating the index
EXPLAIN PLAN FOR
SELECT req.request_status, SUM(req.request_price) as total_price
FROM request req
GROUP BY req.request_status;

-- Display the execution plan after creating the index
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Grant access rights to the other team member
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO XMASHL00;
GRANT SELECT, INSERT, UPDATE, DELETE ON reservation TO XMASHL00;
GRANT SELECT, INSERT, UPDATE, DELETE ON staff TO XMASHL00;
GRANT SELECT, INSERT, UPDATE, DELETE ON waiter TO XMASHL00;
GRANT SELECT, INSERT, UPDATE, DELETE ON request TO XMASHL00;
GRANT SELECT, INSERT, UPDATE, DELETE ON viproom TO XMASHL00;
GRANT SELECT, INSERT, UPDATE, DELETE ON kitchenworker TO XMASHL00;

-- Drop materialized view XMASHL00.vip_customers if it exists
BEGIN
  EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW XMASHL00.vip_customers';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -12003 THEN
      RAISE;
    END IF;
END;
/

-- Create a materialized view to store the number of reservations for each VIP customer
CREATE MATERIALIZED VIEW XMASHL00.vip_customers
AS
SELECT c.id_customer, c.customer_name, COUNT(r.id_reservation) AS num_reservations
FROM customer c
JOIN reservation r ON c.id_customer = r.id_customer
WHERE c.customer_type = 'vip'
GROUP BY c.id_customer, c.customer_name;

-- Refresh the materialized view
EXEC DBMS_MVIEW.REFRESH('xmashl00.vip_customers');

-- Complex SELECT query using WITH clause and CASE operator
-- Purpose: Get the total amount spent by each customer and their customer type (VIP or Regular)
WITH customer_spending AS (
  SELECT c.id_customer, c.customer_name, c.customer_type, SUM(req.request_price) AS total_spent
  FROM customer c
  JOIN request req ON c.id_customer = req.id_customer
  GROUP BY c.id_customer, c.customer_name, c.customer_type
)
SELECT cs.id_customer, cs.customer_name,
       CASE
         WHEN cs.total_spent >= 500 THEN 'VIP'
         ELSE 'Regular'
       END AS calculated_customer_type,
       cs.customer_type AS actual_customer_type,
       cs.total_spent
FROM customer_spending cs;
