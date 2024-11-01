# Group5-Assgniment-plsql
# Employee Attendance Analysis Database


This README provides an overview of the Employee Attendance Analysis Database, we as group 5  did designed to store information of employees and records attendance list of employee then after analysis it using procedure where input parameter is month and year then show you results . We created two tables namely; 'Emplyoyess' table and 'Attendance' table. and procedure called 'Calculate_attendance_statistics'

## Table Structures

### Employee table
``` sql
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY, -- primary key column
    first_name VARCHAR2(20),        -- First name of the employee, up to 20 characters
    last_name VARCHAR2(20)          -- Last name of the employee, up to 20 characters
);
```
### Attendance table
```sql
CREATE TABLE attendance (
    attendance_id NUMBER PRIMARY KEY,   -- Unique identifier for each attendance record
    employee_id NUMBER,                 -- Reference to the employee_id from employees table
    attendance_date DATE,               -- Date of the attendance
    status VARCHAR2(10),                -- Status of the attendance ('Present' or 'Absent')
    CONSTRAINT fk_employee              -- Constraint to ensure employee_id exists in employees table
        FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id),
    CONSTRAINT chk_status               -- Constraint to ensure status is either 'Present' or 'Absent'
        CHECK (status IN ('Present', 'Absent'))
);

```
## Inserting Records

### insert Employee
```sql
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES (101,'Ishimwe','Emile')  
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES (102,'Ndahiriwe','Bienfait')
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES (103,'Arihafi','Moise')
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES (104,'Habimana','Daniel')
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES (105,'Stella','Stella')
```

### Insert Attendance
```sql
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('1', '101', TO_DATE('2024-10-30 07:35:20', 'YYYY-MM-DD HH24:MI:SS'), 'Present')
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('2', '102', TO_DATE('2024-10-30 07:35:38', 'YYYY-MM-DD HH24:MI:SS'), 'Present')
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('3', '103', TO_DATE('2024-10-30 07:35:50', 'YYYY-MM-DD HH24:MI:SS'), 'Absent')
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('4', '104', TO_DATE('2024-10-30 07:35:58', 'YYYY-MM-DD HH24:MI:SS'), 'Absent')
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('5', '105', TO_DATE('2024-10-30 07:36:16', 'YYYY-MM-DD HH24:MI:SS'), 'Present')
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('6', '101', TO_DATE('2024-10-31 07:38:44', 'YYYY-MM-DD HH24:MI:SS'), 'Present')
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('7', '102', TO_DATE('2024-10-31 07:39:02', 'YYYY-MM-DD HH24:MI:SS'), 'Absent')
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('8', '103', TO_DATE('2024-10-31 07:39:13', 'YYYY-MM-DD HH24:MI:SS'), 'Absent')
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('9', '104', TO_DATE('2024-10-31 07:39:24', 'YYYY-MM-DD HH24:MI:SS'), 'Present')
INSERT INTO ATTENDANCE (ATTENDANCE_ID, EMPLOYEE_ID, ATTENDANCE_DATE, STATUS) VALUES ('10', '105', TO_DATE('2024-10-31 07:39:36', 'YYYY-MM-DD HH24:MI:SS'), 'Present')
```
### Conceptual, Logical and Physical Data Model
## PROCEDURE Calculate_attendance
```sql
-- Set the name and parameters of the procedure
CREATE OR REPLACE PROCEDURE calculate_attendance_statistics (
    p_month IN NUMBER,   -- Input parameter for the month
    p_year IN NUMBER     -- Input parameter for the year
) AS
    -- Define a cursor to select all employees
    CURSOR emp_cursor IS
        SELECT employee_id, first_name, last_name
        FROM employees;
        
    -- Declare variables to hold attendance statistics
    v_total_presents NUMBER;                 -- Variable to store total presents
    v_total_absents NUMBER;                  -- Variable to store total absents
    v_attendance_percentage NUMBER;          -- Variable to store attendance percentage
    v_total_days_in_month NUMBER;            -- Variable to store total days in month
    v_full_name VARCHAR2(100);               -- Variable to store employee's full name
    
    -- Define a record type for the employee cursor
    emp_rec emp_cursor%ROWTYPE;
    
    -- Define a cursor to select attendance records for a specific employee
    CURSOR att_cursor (c_emp_id NUMBER) IS
        SELECT status
        FROM attendance
        WHERE employee_id = c_emp_id
          AND EXTRACT(MONTH FROM attendance_date) = p_month  -- Filter by month
          AND EXTRACT(YEAR FROM attendance_date) = p_year;   -- Filter by year
    
    -- Define a record type for the attendance cursor
    att_rec att_cursor%ROWTYPE;
BEGIN
    -- Loop through each employee using the employee cursor
    FOR emp_rec IN emp_cursor LOOP
        -- Initialize counters for presents and absents
        v_total_presents := 0;
        v_total_absents := 0;
        
        -- Concatenate first name and last name to create full name
        v_full_name := emp_rec.first_name || ' ' || emp_rec.last_name;
        
        -- Open the attendance cursor for the current employee
        OPEN att_cursor(emp_rec.employee_id);
        LOOP
            FETCH att_cursor INTO att_rec;  -- Fetch the next attendance record
            EXIT WHEN att_cursor%NOTFOUND;  -- Exit loop when no more records
            
            -- Increment the present or absent counter based on status
            IF att_rec.status = 'Present' THEN
                v_total_presents := v_total_presents + 1;
            ELSIF att_rec.status = 'Absent' THEN
                v_total_absents := v_total_absents + 1;
            END IF;
        END LOOP;
        CLOSE att_cursor;  -- Close the attendance cursor
        
        -- Calculate the total days in the month
        v_total_days_in_month := v_total_presents + v_total_absents;
        
        -- Check if there are any attendance records
        IF v_total_days_in_month > 0 THEN
            -- Calculate the attendance percentage
            v_attendance_percentage := (v_total_presents / v_total_days_in_month) * 100;
            
            -- Display the attendance statistics
            DBMS_OUTPUT.PUT_LINE('Full Name: ' || v_full_name);
            DBMS_OUTPUT.PUT_LINE('Total Presents: ' || v_total_presents);
            DBMS_OUTPUT.PUT_LINE('Total Absents: ' || v_total_absents);
            DBMS_OUTPUT.PUT_LINE('Attendance Percentage: ' || TO_CHAR(v_attendance_percentage, '90.00') || '%');
        ELSE
            -- Indicate that no attendance records were found for the month
            DBMS_OUTPUT.PUT_LINE('Full Name: ' || v_full_name);
            DBMS_OUTPUT.PUT_LINE('No attendance records for the specified month.');
        END IF;
        
        -- Print a separator for readability
        DBMS_OUTPUT.PUT_LINE('------------------------------------');
    END LOOP;

-- Exception handling block
EXCEPTION
    WHEN OTHERS THEN
        -- Handle any unexpected errors
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END calculate_attendance_statistics;
/
```
### Displaying Results
syntax for displaying the results.
```sql
SET SERVEROUTPUT ON;

BEGIN
    calculate_attendance_statistics(10, 2024); -- Example for october 2024
END;

/
```
### Conclusion 
this Employee atendance analysis database was done according to Task give where 

task 1: You are required to create a PL/SQL procedure that performs the following tasks:
<p>1. Calculate Attendance Statistics:</p>
<li>Accept month and year as input parameters to filter attendance records.</li>
<li>Loop through all employees using a FOR loop to retrieve their attendance records for the specified month.</li>
<li>For each employee, use a WHILE loop to count the total number of days marked as 'Present' and 'Absent' during that month.</li>

<p> </p>
<p>2. Display Results:</p>
For each employee, display the following information:
<li>Full name (first and last name)</li>
<li>Total presents</li>
<li>Total absents</li>
<li>Attendance Percentage = (Total Presents/Total Days in the Month) x 100</li>

### Reference 
this site used for getting more expalanation about sql syntax
https://www.geeksforgeeks.org/




