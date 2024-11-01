CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,   -- Unique identifier for each employee
    first_name VARCHAR2(50),          -- First name of the employee, up to 20 characters
    last_name VARCHAR2(50)            -- Last name of the employee, up to 20 characters
);


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
