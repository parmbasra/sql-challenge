-- Use the following sequence to import data into the tables 
--1) title
--2) departments
--3) employees
--4) salaries
--5) department_employee
--6) department_manager


DROP TABLE IF EXISTS title CASCADE;

CREATE TABLE IF NOT EXISTS public.title
(
    title_id VARCHAR(10) NOT NULL PRIMARY KEY,
    title VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE IF NOT EXISTS departments
(
    dept_no VARCHAR(10) NOT NULL PRIMARY KEY,
    dept_name VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE IF NOT EXISTS employees
(
    emp_no INT NOT NULL PRIMARY KEY,
    emp_title_id VARCHAR(10) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    sex VARCHAR(1) NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES title(title_id) 
);


DROP TABLE IF EXISTS salaries CASCADE;

CREATE TABLE IF NOT EXISTS salaries
(
    emp_no integer NOT NULL,
    salary integer NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

DROP TABLE IF EXISTS department_employee;

CREATE TABLE IF NOT EXISTS department_employee
(
    emp_no INT NOT NULL,
    dept_no VARCHAR(10) NOT NULL,
   	PRIMARY KEY (emp_no, dept_no)
);


DROP TABLE IF EXISTS department_manager;

CREATE TABLE IF NOT EXISTS department_manager
(
    dept_no VARCHAR(10) NOT NULL,
    emp_no INT NOT NULL,
    PRIMARY KEY (dept_no, emp_no)
);

select * from employees LIMIT 10;
select * from departments LIMIT 10;
select * from department_employee LIMIT 10;
select * from department_manager LIMIT 10;
select * from salaries LIMIT 10;
select * from title LIMIT 10;

--List the employee number, last name, first name, sex, and salary of each employee.

SELECT emp.emp_no AS "Employee Number", emp.first_name AS "First Name", emp.last_name AS "Last Name",
		emp.sex AS "Sex", sal.salary AS "Salary"
FROM employees emp
INNER JOIN salaries sal
ON emp.emp_no = sal.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT emp.emp_no AS "Employee Number", emp.first_name AS "First Name", emp.last_name AS "Last Name", emp.hire_date AS "Hire Date"
FROM employees emp
WHERE DATE_PART('year', hire_date) = 1986;

--List the manager of each department along with their department number, department name, employee number, last name, and first name.

SELECT dept.dept_no AS "Department Number", dept.dept_name AS "Department Name", 
		emp.emp_no AS "Employee Number", emp.first_name AS "First Name", emp.last_name AS "Last Name"
FROM departments dept
INNER JOIN department_manager deptman ON dept.dept_no = deptman.dept_no
INNER JOIN employees emp ON emp.emp_no = deptman.emp_no
WHERE emp.emp_title_id = (Select title_id FROM title WHERE title = 'Manager')
GROUP BY dept.dept_no, emp.emp_no;

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

SELECT dept.dept_no AS "Department Number", dept.dept_name AS "Department Name", 
		emp.emp_no AS "Employee Number", emp.first_name AS "First Name", emp.last_name AS "Last Name"
FROM departments dept
INNER JOIN department_employee deptemp ON dept.dept_no = deptemp.dept_no
INNER JOIN employees emp ON emp.emp_no = deptemp.emp_no
GROUP BY dept.dept_no,emp.emp_no;

--List the first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

SELECT  emp.first_name AS "First Name", emp.last_name AS "Last Name",
		emp.sex AS "Sex"
FROM employees emp 
WHERE emp.first_name = 'Hercules' and emp.last_name LIKE 'B%'
ORDER BY emp.sex;


--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT  dept.dept_name AS "Department Name", 
		emp.emp_no AS "Employee Number", emp.first_name AS "First Name", emp.last_name AS "Last Name"
FROM departments dept
INNER JOIN department_employee deptemp ON dept.dept_no = deptemp.dept_no
INNER JOIN employees emp ON emp.emp_no = deptemp.emp_no
WHERE dept.dept_name = 'Sales'
GROUP BY dept.dept_name,emp.emp_no;


--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT  dept.dept_name AS "Department Name", 
		emp.emp_no AS "Employee Number", emp.first_name AS "First Name", emp.last_name AS "Last Name"
FROM departments dept
INNER JOIN department_employee deptemp ON dept.dept_no = deptemp.dept_no
INNER JOIN employees emp ON emp.emp_no = deptemp.emp_no
WHERE dept.dept_name = 'Sales' OR dept.dept_name = 'Development'
ORDER BY emp.emp_no;


--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT last_name, COUNT(last_name) AS "Count of Last Name"
FROM employees
GROUP BY last_name
ORDER BY "Count of Last Name" DESC;

-- List how many employees each department contains
SELECT  dept.dept_name AS "Department Name", COUNT(emp.emp_no) AS "Number of Employee" 
FROM departments dept
INNER JOIN department_employee deptemp ON dept.dept_no = deptemp.dept_no
INNER JOIN employees emp ON emp.emp_no = deptemp.emp_no
GROUP BY dept.dept_name
ORDER BY dept.dept_name;




