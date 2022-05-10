DROP TABLE assignments;
DROP TABLE animals;
DROP TABLE enclosures;
DROP TABLE employees;

CREATE TABLE enclosures (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    capacity INT,
    closedForMaintenance BOOLEAN
);

CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(255),
    age INT,
    enclosure_id INT REFERENCES enclosures(id)
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    employeeNumber INT
);

CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    enclosure_id INT REFERENCES enclosures(id),
    weekday VARCHAR(255)
);

INSERT INTO enclosures (name, capacity, closedForMaintenance) VALUES ('Elephants', 10, True);
INSERT INTO enclosures (name, capacity, closedForMaintenance) VALUES ('Lions', 5, False);
INSERT INTO enclosures (name, capacity, closedForMaintenance) VALUES ('Monkeys', 15, False);
INSERT INTO enclosures (name, capacity, closedForMaintenance) VALUES ('Pandas', 20, False);

INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Nelly', 'Elephant', 5, 1);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Elly', 'Elephant', 7, 1);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Simba', 'Lion', 2, 2);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('George', 'Monkey', 5, 3);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Po', 'Panda', 8, 4);

INSERT INTO employees (name, employeeNumber) VALUES ('Steve Irwin', 25);
INSERT INTO employees (name, employeeNumber) VALUES ('John Doe', 41);
INSERT INTO employees (name, employeeNumber) VALUES ('Bob Mccan', 23);
INSERT INTO employees (name, employeeNumber) VALUES ('James Backshaw', 31);

INSERT INTO assignments (weekday, employee_id, enclosure_id) VALUES ('MONDAY', 1, 1);
INSERT INTO assignments (weekday, employee_id, enclosure_id) VALUES ('WEDNESDAY', 2, 2);
INSERT INTO assignments (weekday, employee_id, enclosure_id) VALUES ('FRIDAY', 3, 3);
INSERT INTO assignments (weekday, employee_id, enclosure_id) VALUES ('SATURDAY', 4, 4);


-- QUERIES -------------------------------------
-- Find the names of the animals in a given enclosure:
-- e.g. where enclosure_id = 1:
SELECT (name) FROM animals WHERE enclosure_id = 1;

-- Find the names of the staff working in a given enclosure:
-- e.g. where enclosure_id = 1:
SELECT (name) 
FROM assignments 
INNER JOIN employees 
ON assignments.employee_id = employees.id 
WHERE enclosure_id = 1;

-- Find the names of the staff working in enclosures which are closed for maintenance:
SELECT employees.name FROM employees 
INNER JOIN assignments
ON employees.id = assignments.employee_id
INNER JOIN enclosures
ON enclosures.id = assignments.enclosure_id
WHERE closedForMaintenance IS TRUE;

-- Find the name of the enclosure where the oldest animal lives. 
-- If there are two animals who are the same age choose the first one alphabetically.
SELECT enclosures.name FROM enclosures
INNER JOIN animals
ON enclosures.id = animals.enclosure_id
ORDER BY age DESC, animals.name LIMIT 1;

-- The number of different animal types a given keeper has been assigned to work with.
SELECT COUNT (DISTINCT type) 
FROM animals
INNER JOIN assignments
ON animals.enclosure_id = assignments.enclosure_id
WHERE employee_id = 1;

-- The number of different keepers who have been assigned to work in a given enclosure.
SELECT COUNT (DISTINCT employee_id)
FROM assignments
WHERE enclosure_id = 1;