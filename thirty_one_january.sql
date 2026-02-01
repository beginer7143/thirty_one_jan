USE THIRTY_JAN_DB;

/*
Database Challenges
Challenge 1: Student & Course Enrollment
Schema
●	students(student_id PK, name, city)
●	courses(course_id PK, course_name)
●	enrollments(enroll_id PK, student_id FK, course_id FK, enroll_date)
Tasks
1.	Write CREATE TABLE statements with PK & FK.
2.	Insert at least 5 students and 3 courses.
3.	Write a query to show:
○	Student name + course name
4.	Find students not enrolled in any course.
*/

-- ●	students(student_id PK, name, city)
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);

-- ●	courses(course_id PK, course_name)
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

-- ●	enrollments(enroll_id PK, student_id FK, course_id FK, enroll_date)
CREATE TABLE enrollments (
    enroll_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enroll_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
-- 2.	Insert at least 5 students and 3 courses.
INSERT INTO students VALUES (1,'Amit','Pune'), (2,'Riya','Mumbai'), (3,'Kunal','Nagpur'), (4,'Neha','Delhi'), (5,'Rohit','Pune');

INSERT INTO courses VALUES (101,'DBMS'), (102,'Java'), (103,'Python');

INSERT INTO enrollments VALUES (1,1,101,'2024-01-10'), (2,1,102,'2024-01-12'), (3,2,101,'2024-01-15'), (4,3,103,'2024-01-18');

-- 3.	Write a query to show:
-- ○	Student name + course name
SELECT s.name, c.course_name FROM students s JOIN enrollments e ON s.student_id = e.student_id JOIN courses c ON e.course_id = c.course_id;

-- 4.	Find students not enrolled in any course.
SELECT s.name FROM students s LEFT JOIN enrollments e ON s.student_id = e.student_id WHERE e.student_id IS NULL;

/*
Challenge 2: Company & Employees
Schema
●	company(company_id PK, company_name)
●	employee(emp_id PK, emp_name, salary, company_id FK)
Tasks
1.	Design schema with PK & FK.
2.	List employees working in each company.
3.	Find companies with no employees.
4.	Show company name + total salary paid.
*/

-- ●	company(company_id PK, company_name)
CREATE TABLE company ( company_id INT PRIMARY KEY, company_name VARCHAR(50) );

-- ●	employee(emp_id PK, emp_name, salary, company_id FK)
CREATE TABLE employee (emp_id INT PRIMARY KEY, emp_name VARCHAR(50), salary INT, company_id INT, FOREIGN KEY (company_id) REFERENCES company(company_id) );

-- 2.	List employees working in each company.
SELECT c.company_name, e.emp_name FROM company c LEFT JOIN employee e ON c.company_id = e.company_id;

-- 3.	Find companies with no employees.
SELECT c.company_name FROM company c LEFT JOIN employee e ON c.company_id = e.company_id WHERE e.emp_id IS NULL;

-- 4.	Show company name + total salary paid.
SELECT c.company_name, SUM(e.salary) AS total_salary FROM company c LEFT JOIN employee e ON c.company_id = e.company_id GROUP BY c.company_name;

/*
Challenge 3: Orders & Customers
Schema
●	customers(customer_id PK, customer_name, city)
●	orders(order_id PK, order_date, amount, customer_id FK)
Tasks
1.	Write schema.
2.	Display customer name + order amount.
3.	Find customers who never placed any order.
4.	Show city-wise total order amount.
*/

-- ●	customers(customer_id PK, customer_name, city)
CREATE TABLE customers (    customer_id INT PRIMARY KEY,    customer_name VARCHAR(50),    city VARCHAR(50) );

-- ●	orders(order_id PK, order_date, amount, customer_id FK)
CREATE TABLE orders (    order_id INT PRIMARY KEY,    order_date DATE,    amount INT,    customer_id INT,    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) );

-- 2.	Display customer name + order amount.
SELECT c.customer_name, o.amount FROM customers c JOIN orders o ON c.customer_id = o.customer_id;

-- 3.	Find customers who never placed any order.
SELECT c.customer_name FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id WHERE o.order_id IS NULL;

-- 4.	Show city-wise total order amount.
SELECT c.city, SUM(o.amount) AS total_amount FROM customers c JOIN orders o ON c.customer_id = o.customer_id GROUP BY c.city;

/*
Challenge 4: INNER JOIN Practice
Using customers and orders
Tasks
1.	Show only customers who placed orders.
2.	Display order_id, customer_name, amount.
3.	Filter orders above ₹5000.
*/
SELECT c.customer_name, o.order_id, o.amount FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id WHERE o.amount > 5000;

/*
Challenge 5: LEFT JOIN Logic Test
Using same schema
Tasks
1.	Show all customers even if no order exists.
2.	Identify customers with NULL orders.
3.	Count orders per customer.
*/
-- 1.	Show all customers even if no order exists.
SELECT c.customer_name, o.amount FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 2.	Identify customers with NULL orders.
SELECT c.customer_name FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id WHERE o.order_id IS NULL;

-- 3.	Count orders per customer.
SELECT c.customer_name, COUNT(o.order_id) AS order_count FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id GROUP BY c.customer_name;

/*
Challenge 6: RIGHT JOIN Scenario
Schema
●	trainers(trainer_id PK, trainer_name)
●	batches(batch_id PK, batch_name, trainer_id FK)
Tasks
1.	Show all batches including those without trainers.
2.	Display trainer name if assigned, else NULL.
*/

-- ●	trainers(trainer_id PK, trainer_name)
CREATE TABLE trainers (    trainer_id INT PRIMARY KEY,    trainer_name VARCHAR(50) );

-- ●	batches(batch_id PK, batch_name, trainer_id FK)
CREATE TABLE batches (    batch_id INT PRIMARY KEY,    batch_name VARCHAR(50),    trainer_id INT,    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id) );

SELECT b.batch_name, t.trainer_name
FROM trainers t
RIGHT JOIN batches b ON t.trainer_id = b.trainer_id;

/*
Challenge 7: FULL JOIN Equivalent 
Using students and enrollments
Tasks
1.	Show:
○	Students with enrollment
○	Students without enrollment
2.	(Use LEFT JOIN + UNION + RIGHT JOIN logic)

*/
SELECT s.student_id, e.enroll_id 
FROM students s 
LEFT JOIN enrollments e ON s.student_id = e.student_id 
UNION
SELECT s.student_id, e.enroll_id
FROM students s
RIGHT JOIN enrollments e ON s.student_id = e.student_id;

/*
Challenge 8: Foreign Key Constraint Test
Schema
●	department(dept_id PK, dept_name)
●	employee(emp_id PK, emp_name, dept_id FK)
Tasks
1.	Insert employee with invalid dept_id → observe error.
2.	Explain why error occurred.
3.	Fix data and re-insert.
*/
-- ●	department(dept_id PK, dept_name)
create table departments( dept_id int primary key, dept_name varchar(100));

-- ●	employee(emp_id PK, emp_name, dept_id FK)
create table employees( emp_id int primary key, emp_name varchar(100), dept_id int unique, foreign key(dept_id) references departments(dept_id));

-- 1.	Insert employee with invalid dept_id → observe error.
INSERT INTO departments VALUES (10,'IT');

-- 3.	Fix data and re-insert.
INSERT INTO employees VALUES (1,'Rahul',10);

/*
Challenge 9: Delete with FK Dependency
Using same schema
Tasks
1.	Try deleting a department having employees.
2.	Observe error.
3.	Write correct delete logic (delete child rows first).
*/

-- 1.	Try deleting a department having employees.
DELETE FROM departments WHERE dept_id = 10;

-- 3.	Write correct delete logic (delete child rows first).
DELETE FROM employees WHERE dept_id = 10;
DELETE FROM departments WHERE dept_id = 10;

/*
Challenge 10: Update PK Impact
Tasks
1.	Update dept_id in department table.
2.	Observe FK behavior.
3.	Explain why PK should not be frequently updated.
*/

-- 1.	Update dept_id in department table.
UPDATE departments SET dept_id = 20 WHERE dept_id = 10;



/*
Challenge 11: College Placement System
Schema
●	students(student_id PK, name)
●	companies(company_id PK, company_name)
●	placements(place_id PK, student_id FK, company_id FK, package)
Tasks
1.	Show student name + company name + package.
2.	Find students not placed.
3.	Find company offering highest package.
*/

-- ●	students(student_id PK, name)
create table student (student_id int primary key, name varchar(50));

-- ●	companies(company_id PK, company_name)
create table companies(company_id int primary key, company_name varchar(50));

-- ●	placements(place_id PK, student_id FK, company_id FK, package)
create table placements( place_id int primary key, student_id int unique, company_id int unique, package int, 
foreign key( student_id) references student(student_id),
foreign key(company_id) references companies(company_id));

-- 1.	Show student name + company name + package.
SELECT s.name, c.company_name, p.package
FROM placements p
JOIN student s ON p.student_id = s.student_id
JOIN companies c ON p.company_id = c.company_id;

-- 2.	Find students not placed.
SELECT s.name
FROM student s
LEFT JOIN placements p ON s.student_id = p.student_id
WHERE p.place_id IS NULL;

-- 3.	Find company offering highest package.
SELECT company_name
FROM companies
WHERE company_id =
(SELECT company_id FROM placements ORDER BY package DESC LIMIT 1);

/*
Challenge 12: Online Shopping
Schema
●	products(product_id PK, product_name, price)
●	order_items(item_id PK, order_id, product_id FK, quantity)
Tasks
1.	Display product name + quantity.
2.	Find products never ordered.
3.	Calculate total price per product.
*/
-- ●	products(product_id PK, product_name, price)
create table products (product_id int primary key, product_name varchar(50), price int);

-- ●	order_items(item_id PK, order_id, product_id FK, quantity)
create table items (item_id int primary key, order_id int, 
product_id int unique, quantity int,
 foreign key(product_id) references products(product_id));

-- 1.	Display product name + quantity.
SELECT p.product_name, i.quantity
FROM products p
JOIN items i ON p.product_id = i.product_id;

-- 2.	Find products never ordered.
SELECT p.product_name
FROM products p
LEFT JOIN items i ON p.product_id = i.product_id
WHERE i.product_id IS NULL;

-- 3.	Calculate total price per product.
SELECT p.product_name, SUM(p.price * i.quantity) AS total_price
FROM products p
JOIN items i ON p.product_id = i.product_id
GROUP BY p.product_name;

/*
Challenge 13: Banking System
Schema
●	accounts(account_id PK, holder_name)
●	transactions(txn_id PK, account_id FK, amount, txn_type)
Tasks
1.	Show account holder + transaction amount.
2.	Find accounts with no transactions.
3.	Calculate total credit & debit per account.
*/
-- ●	accounts(account_id PK, holder_name)
create table accounts (account_id int primary key , holder_name varchar(50));

-- ●	transactions(txn_id PK, account_id FK, amount, txn_type)
create table transactions(txn_id int primary key, account_id int unique,
 amount double, txn_type varchar(50), 
foreign key(account_id) references accounts(account_id));

-- 1.	Show account holder + transaction amount.
SELECT a.holder_name, t.amount
FROM accounts a
JOIN transactions t ON a.account_id = t.account_id;

-- 2.	Find accounts with no transactions.
SELECT a.holder_name
FROM accounts a
LEFT JOIN transactions t ON a.account_id = t.account_id
WHERE t.txn_id IS NULL;

-- 3.	Calculate total credit & debit per account.
SELECT account_id,
SUM(CASE WHEN txn_type='credit' THEN amount ELSE 0 END) AS total_credit,
SUM(CASE WHEN txn_type='debit' THEN amount ELSE 0 END) AS total_debit
FROM transactions
GROUP BY account_id;

/*
Challenge 14: Employee & Manager (Self-Join)
Schema
●	employee(emp_id PK, emp_name, manager_id)
Tasks
1.	Show employee name + manager name.
2.	Identify employees without managers.
*/
-- employee(emp_id PK, emp_name, manager_id)
create table employeess(emp_id int primary key, emp_name varchar(50), manager_id int);

-- 1.	Show employee name + manager name.
SELECT e.emp_name AS employeess, m.emp_name AS manager
FROM employeess e
LEFT JOIN employeess m ON e.manager_id = m.emp_id;

-- 2.	Identify employees without managers.
SELECT emp_name
FROM employeess
WHERE manager_id IS NULL;

/*
Challenge 15: Multi-Table Join
Using:
●	students
●	courses
●	enrollments
Tasks
1.	Show student + course.
2.	Count students per course.
3.	Find courses with zero students.
*/
-- 1.	Show student + course.
SELECT s.name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 2.	Count students per course.
SELECT c.course_name, COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- 3.	Find courses with zero students.
SELECT c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

















