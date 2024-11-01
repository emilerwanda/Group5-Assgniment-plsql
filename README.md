# Group5-Assgniment-plsql
<U>#Employee Attendance Analysis Database</U>


This README provides an overview of the Employee Attendance Analysis Database, we as group 5  did designed to store information of employees and records attendance list of employee then after analysis it using procedure where input parameter is month and year then show you results . We created two tables namely; 'Emplyoyess' table and 'Attendance' table. and procedure called 'Calculate_attendance'

##Table Structures

###Employee table
``` sql
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY, -- primary key column
    first_name VARCHAR2(50),
    last_name VARCHAR2(50)
);
```
###Attendance table
```sql
CREATE TABLE attendance (
    attendance_id NUMBER PRIMARY KEY, --primary key column
    employee_id NUMBER,
    attendance_date DATE,
    status VARCHAR2(10),
    CONSTRAINT fk_employee
     FOREIGN KEY (employee_id)  
     REFERENCES employees(employee_id), -- foreign key column referenced from employye table
    CONSTRAINT chk_status
        CHECK (status IN ('Present', 'Absent')) -- constraint to check input matches with given
);
```
##Inserting Records

###insert Employee
```sql
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES(101,'Ishimwe','Emile')  
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES(102,'Ndahiriwe','Bienfait')
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES(103,'Arihafi','Moise')
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES(104,'Habimana','Daniel')
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME) VALUES(105,'Stella','Stella')
```

###Insert Attendance
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
###Conceptual, Logical and Physical Data Model
##PROCEDURE Calculate_attendance
```sql
CREATE OR REPLACE PROCEDURE calculate_attendance_
( p_month IN NUMBER, p_year IN NUMBER) AS
  CURSOR emp_cursor IS
    SELECT employee_id, first_name, last_name
    FROM employees;
    
    v_total_presents NUMBER;
    v_total_absents NUMBER;
    v_attendance_percentage NUMBER;
    v_total_days_in_month NUMBER;
    v_full_name VARCHAR2(100);
    
    emp_rec emp_cursor%ROWTYPE;
    CURSOR att_cursor (c_emp_id NUMBER) IS
        SELECT status
        FROM attendance
        WHERE employee_id = c_emp_id
            AND EXTRACT(MONTH FROM attendance_date) = p_month
          AND EXTRACT(YEAR FROM attendance_date) = p_year;
    att_rec att_cursor%ROWTYPE;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        v_total_presents := 0;
        v_total_absents := 0;
        v_full_name := emp_rec.first_name || ' ' || emp_rec.last_name;
        OPEN att_cursor(emp_rec.employee_id);
        LOOP
            FETCH att_cursor INTO att_rec;
            EXIT WHEN att_cursor%NOTFOUND;
            
            IF att_rec.status = 'Present' THEN
                v_total_presents := v_total_presents + 1;
            ELSIF att_rec.status = 'Absent' THEN
                v_total_absents := v_total_absents + 1;
            END IF;
        END LOOP;
        CLOSE att_cursor;     
        v_total_days_in_month := v_total_presents + v_total_absents;
        
        IF v_total_days_in_month > 0 THEN
            v_attendance_percentage := (v_total_presents / v_total_days_in_month) * 100;
            
            DBMS_OUTPUT.PUT_LINE('Full Name: ' || v_full_name);
            DBMS_OUTPUT.PUT_LINE('Total Presents: ' || v_total_presents);
            DBMS_OUTPUT.PUT_LINE('Total Absents: ' || v_total_absents);
            DBMS_OUTPUT.PUT_LINE('Attendance Percentage: ' || TO_CHAR(v_attendance_percentage, '90.00') || '%');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Full Name: ' || v_full_name);
            DBMS_OUTPUT.PUT_LINE('No attendance records for the specified month.');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('------------------------------------');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END calculate_attendance;
/
```
###Conclusion 
this Employee atendance analysis database was done according to Task give where 
task 1: You are required to create a PL/SQL procedure that performs the following tasks:
1. Calculate Attendance Statistics:
▪Accept month and year as input parameters to filter attendance records.
▪Loop through all employees using a FOR loop to retrieve their attendance records for the specified month.
▪For each employee, use a WHILE loop to count the total number of days marked as 'Present' and 'Absent' during that month.

2. Display Results:
For each employee, display the following information:
▪Full name (first and last name)
▪Total presents
▪Total absents
▪Attendance Percentage = (Total Presents/Total Days in the Month) x 100

###Reference 



