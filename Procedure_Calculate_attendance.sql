
-- Set the name and parameters of the procedure
CREATE OR REPLACE PROCEDURE calculate_attendance_ (
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
        DBMS_OUT.PUT_LINE('Error  code' || SQLERRCODE);

END calculate_attendance_;
/

