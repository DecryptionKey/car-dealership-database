-- Car Dealership Management System (PostgreSQL)
-- Schema, sample data, views, a stored procedure, a trigger, and role-based access control.
-- All people, emails, and phone numbers are fictional sample data.

-- ================================
-- Customers
-- ================================
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(12) NOT NULL CHECK (phone ~ '^[0-9]{3}-[0-9]{3}-[0-9]{4}$'),
    street_address TEXT,
    city VARCHAR(50),
    state VARCHAR(2) CHECK (state ~ '^[A-Z]{2}$'),
    zipcode VARCHAR(10) CHECK (zipcode ~ '^[0-9]{5}(-[0-9]{4})?$'),
    country VARCHAR(50) DEFAULT 'USA'
);

INSERT INTO customers (first_name, last_name, email, phone, street_address, city, state, zipcode, country) VALUES
('Alan', 'Lab', 'alan.lab@example.com', '555-555-0101', '123 Alan Blvd', 'Database', 'NY', '10021', 'USA'),
('Grace', 'Hopper', 'grace.hopper@example.com', '555-555-0102', '456 Grace St', 'Quover City', 'VA', '20012', 'USA'),
('Ada', 'Lovelace', 'ada.lovelace@example.com', '555-555-0103', '749 Loveland Ave', 'Analytica', 'CA', '90003', 'USA'),
('Linus', 'Torvalds', 'linus.torvalds@example.com', '555-555-0104', '777 Kernel Ln', 'Linuxville', 'OR', '97035', 'USA'),
('Margaret', 'Hamilton', 'margaret.hamilton@example.com', '555-555-0105', '901 Apollo Dr', 'Moonbaze', 'TX', '73301', 'USA');

-- ================================
-- Employees
-- ================================
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('Sales Rep', 'Service Tech', 'Manager', 'Owner')),
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(12) CHECK (phone ~ '^[0-9]{3}-[0-9]{3}-[0-9]{4}$'),
    street_address TEXT,
    city VARCHAR(50),
    state VARCHAR(2) CHECK (state ~ '^[A-Z]{2}$'),
    zipcode VARCHAR(10) CHECK (zipcode ~ '^[0-9]{5}(-[0-9]{4})?$'),
    country VARCHAR(50) DEFAULT 'USA'
);

INSERT INTO employees (first_name, last_name, role, email, phone, street_address, city, state, zipcode, country) VALUES
('Elon', 'Musk', 'Manager', 'elon.musk@example.com', '555-555-0106', '1 Innovation Way', 'Austin', 'TX', '73301', 'USA'),
('Sheryl', 'Sandberg', 'Manager', 'sheryl.sandberg@example.com', '555-555-0107', '2 Network Ave', 'San Jose', 'CA', '95110', 'USA'),
('Tim', 'Cook', 'Manager', 'tim.cook@example.com', '555-555-0108', '3 Orchard Ln', 'Cupertino', 'CA', '95014', 'USA'),
('Tony', 'Stark', 'Sales Rep', 'tony.stark@example.com', '555-555-0109', '10880 Malibu Point', 'Malibu', 'CA', '90265', 'USA'),
('Peter', 'Parker', 'Sales Rep', 'peter.parker@example.com', '555-555-0110', '20 Ingram St', 'Queens', 'NY', '11375', 'USA'),
('Clark', 'Kent', 'Sales Rep', 'clark.kent@example.com', '555-555-0111', '344 Clinton St', 'Metropolis', 'NY', '10001', 'USA'),
('Bruce', 'Wayne', 'Service Tech', 'bruce.wayne@example.com', '555-555-0112', '1007 Mountain Dr', 'Gotham', 'NJ', '07001', 'USA'),
('Diana', 'Prince', 'Service Tech', 'diana.prince@example.com', '555-555-0113', '200 Themyscira Blvd', 'Themyscira', 'MA', '02101', 'USA'),
('Steve', 'Rogers', 'Service Tech', 'steve.rogers@example.com', '555-555-0114', '569 Lehigh St', 'Brooklyn', 'NY', '11201', 'USA'),
('Nye', 'Wade', 'Owner', 'nye.wade@example.com', '555-555-0115', '1 Admin Plaza', 'Poughkeepsie', 'NY', '12601', 'USA');

-- ================================
-- Cars
-- ================================
CREATE TABLE cars (
    vin VARCHAR(17) PRIMARY KEY,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL CHECK (year >= 1980 AND year <= EXTRACT(YEAR FROM CURRENT_DATE) + 1),
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'sold', 'reserved')),
    mileage INT DEFAULT 0 CHECK (mileage >= 0),
    condition VARCHAR(10) GENERATED ALWAYS AS (CASE WHEN mileage <= 150 THEN 'new' ELSE 'used' END) STORED
);

INSERT INTO cars (vin, make, model, year, price, status, mileage) VALUES
('WBAJA7C57JG123456', 'BMW', '530i', 2018, 35000.00, 'available', 20000),
('WBAJA9C53KB789012', 'BMW', '540i', 2019, 42000.00, 'available', 15000),
('WBS8M9C56LBU34567', 'BMW', 'M3', 2020, 70000.00, 'available', 10000),
('WBSJF0C53KB678910', 'BMW', 'M5', 2026, 105000.00, 'available', 50),
('WBAGX5C51MC654321', 'BMW', 'X5', 2022, 60000.00, 'available', 3000),
('WBA4J7C50LBU78901', 'BMW', '430i', 2025, 59030.00, 'available', 110);

-- ================================
-- Sales
-- ================================
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    employee_id INT REFERENCES employees(employee_id),
    car_vin VARCHAR(17) REFERENCES cars(vin),
    sale_date DATE DEFAULT CURRENT_DATE,
    sale_price NUMERIC(10,2) CHECK (sale_price > 0)
);

INSERT INTO sales (customer_id, employee_id, car_vin, sale_price) VALUES
(1, 4, 'WBAJA7C57JG123456', 35000.00),
(2, 5, 'WBAJA9C53KB789012', 42000.00),
(3, 6, 'WBS8M9C56LBU34567', 70000.00),
(4, 6, 'WBSJF0C53KB678910', 105000.00),
(5, 4, 'WBAGX5C51MC654321', 60000.00),
(1, 5, 'WBA4J7C50LBU78901', 59030.00);

-- ================================
-- Financing
-- ================================
CREATE TABLE financing (
    finance_id SERIAL PRIMARY KEY,
    sale_id INT REFERENCES sales(sale_id),
    amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    interest_rate NUMERIC(4,2) CHECK (interest_rate >= 0),
    term_months INT CHECK (term_months > 0)
);

INSERT INTO financing (sale_id, amount, interest_rate, term_months) VALUES
(1, 25000.00, 2.9, 36);

-- ================================
-- Suppliers
-- ================================
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(12) CHECK (phone ~ '^[0-9]{3}-[0-9]{3}-[0-9]{4}$'),
    street_address TEXT,
    city VARCHAR(50),
    state VARCHAR(2) CHECK (state ~ '^[A-Z]{2}$'),
    zipcode VARCHAR(10) CHECK (zipcode ~ '^[0-9]{5}(-[0-9]{4})?$'),
    country VARCHAR(50) DEFAULT 'USA'
);

INSERT INTO suppliers (name, email, phone, street_address, city, state, zipcode, country) VALUES
('Bavarian Auto Supply', 'orders@bavarian-auto.example.com', '555-555-0116', '99 Auto Dr', 'Munich', 'BY', '80331', 'Germany'),
('EuroParts Ltd.', 'contact@europarts.example.com', '555-555-0117','77 Gear Ave', 'Stuttgart', 'BW', '70173', 'Germany');

-- ================================
-- Inventory Parts
-- ================================
CREATE TABLE inventory_parts (
    part_id SERIAL PRIMARY KEY,
    part_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    supplier_id INT REFERENCES suppliers(supplier_id)
);

INSERT INTO inventory_parts (part_name, quantity, supplier_id) VALUES
('Oil Filter', 50, 1),
('Brake Pads', 30, 1),
('Air Filter', 40, 2),
('Cabin Filter', 20, 2),
('Spark Plugs', 60, 1);

-- ================================
-- Service Appointments
-- ================================
CREATE TABLE service_appointments (
    appointment_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    car_vin VARCHAR(17) REFERENCES cars(vin),
    employee_id INT REFERENCES employees(employee_id),
    appointment_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'canceled'))
);

INSERT INTO service_appointments (customer_id, car_vin, employee_id, appointment_date, status) VALUES
(2, 'WBAJA9C53KB789012', 3, CURRENT_TIMESTAMP + INTERVAL '3 days', 'scheduled'),
(3, 'WBS8M9C56LBU34567', 3, CURRENT_TIMESTAMP + INTERVAL '5 days', 'scheduled'),
(4, 'WBSJF0C53KB678910', 3, CURRENT_TIMESTAMP + INTERVAL '7 days', 'scheduled');

-- ================================
-- Service Records
-- ================================
CREATE TABLE service_records (
    record_id SERIAL PRIMARY KEY,
    appointment_id INT REFERENCES service_appointments(appointment_id),
    part_id INT REFERENCES inventory_parts(part_id),
    description TEXT,
    cost NUMERIC(10,2) CHECK (cost >= 0)
);

INSERT INTO service_records (appointment_id, part_id, description, cost) VALUES
(1, 1, 'Replaced oil filter and changed oil', 75.00),
(2, 2, 'Replaced brake pads and checked brake fluid', 250.00),
(3, 3, 'Changed air filter and ran diagnostics', 120.00);

-- ================================
-- Views
-- ================================
CREATE VIEW detailed_service_appointments AS
SELECT sa.*,
       c.first_name || ' ' || c.last_name AS customer,
       e.first_name || ' ' || e.last_name AS technician,
       ca.make, ca.model
FROM service_appointments sa
JOIN customers c ON sa.customer_id = c.customer_id
JOIN employees e ON sa.employee_id = e.employee_id
JOIN cars ca ON sa.car_vin = ca.vin;

CREATE VIEW new_inventory AS
SELECT * FROM cars WHERE condition = 'new' AND status = 'available';

CREATE VIEW used_inventory AS
SELECT * FROM cars WHERE condition = 'used' AND status = 'available';

CREATE VIEW bmw_inventory AS
SELECT * FROM cars WHERE make = 'BMW' AND status = 'available' AND condition = 'new';

CREATE VIEW top_customers AS
SELECT c.first_name || ' ' || c.last_name AS full_name, COUNT(s.sale_id) AS total_purchases
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_purchases DESC;

-- ================================
-- Stored Procedure: Register Sale
-- ================================
CREATE OR REPLACE FUNCTION register_sale(
    p_customer_id INT, p_employee_id INT, p_car_vin VARCHAR, p_sale_price NUMERIC
) RETURNS VOID AS $$
BEGIN
    INSERT INTO sales (customer_id, employee_id, car_vin, sale_price)
    VALUES (p_customer_id, p_employee_id, p_car_vin, p_sale_price);

    UPDATE cars SET status = 'sold' WHERE vin = p_car_vin;
END;
$$ LANGUAGE plpgsql;


-- ================================
-- Trigger: After Car Sold
-- ================================
CREATE OR REPLACE FUNCTION after_car_sold() RETURNS TRIGGER AS $$
DECLARE
    tech_id INT;
BEGIN
    SELECT employee_id INTO tech_id
    FROM employees
    WHERE role = 'Service Tech'
    ORDER BY RANDOM()
    LIMIT 1;

    INSERT INTO service_appointments (customer_id, car_vin, employee_id, appointment_date)
    VALUES (NEW.customer_id, NEW.car_vin, tech_id, CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_after_sale
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION after_car_sold();

-- ================================
-- Role and Permission Setup
-- ================================
-- Owner Role

CREATE ROLE owner_role;

-- Grant full access to all tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO owner_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO owner_role;

-- Grant access to all views
GRANT SELECT ON bmw_inventory, used_inventory, new_inventory, top_customers, 
              detailed_service_appointments TO owner_role;

-- Grant execution privileges for all functions
GRANT EXECUTE ON FUNCTION register_sale, after_car_sold TO owner_role;

-- Owner can grant and take privileges
ALTER ROLE owner_role WITH ADMIN OPTION;




-- Manager Role

CREATE ROLE manager_role;

-- Grant access to tables needed for managing the dealership
GRANT SELECT, INSERT, UPDATE, DELETE ON customers, employees, cars, 
                                         sales, financing, suppliers, 
                                         inventory_parts, service_appointments, 
                                         service_records TO manager_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO manager_role;

-- Grant access to relevant views
GRANT SELECT ON bmw_inventory, used_inventory, new_inventory, 
              top_customers, detailed_service_appointments TO manager_role;

-- Grant execution privileges for management functions
GRANT EXECUTE ON FUNCTION register_sale TO manager_role;




-- Sales Rep Role

CREATE ROLE sales_rep_role;

-- Grant limited access to customer and inventory data
GRANT SELECT ON cars, customers TO sales_rep_role;
GRANT INSERT ON sales TO sales_rep_role;
GRANT SELECT ON financing TO sales_rep_role;
GRANT INSERT ON financing TO sales_rep_role;

-- Restrict permissions on employee data
GRANT SELECT (employee_id, first_name, last_name, role) ON employees TO sales_rep_role;

-- Grant access to relevant views for sales
GRANT SELECT ON bmw_inventory, new_inventory, top_customers TO sales_rep_role;

-- Grant execution privileges for sales functions
GRANT EXECUTE ON FUNCTION register_sale TO sales_rep_role;




-- Service Tech Role

CREATE ROLE service_tech_role;

-- Grant access to service-related tables
GRANT SELECT ON cars, customers, inventory_parts TO service_tech_role;
GRANT SELECT, INSERT, UPDATE ON service_appointments, service_records TO service_tech_role;

-- Grant limited access to suppliers for parts ordering
GRANT SELECT ON suppliers TO service_tech_role;

-- Restrict permissions on sales data
REVOKE ALL PRIVILEGES ON sales, financing FROM service_tech_role;

-- Grant access to service-relevant views
GRANT SELECT ON used_inventory, detailed_service_appointments TO service_tech_role;


-- ================================
-- User Assignment
-- ================================
-- Demo accounts only. Set real passwords before using this anywhere.

-- Owner (Full Access)
CREATE USER nye_wade WITH PASSWORD 'change_me';
GRANT owner_role TO nye_wade;
ALTER USER nye_wade CREATEROLE;  -- I can create new roles because I’m a boss!

-- Managers
CREATE USER elon_musk WITH PASSWORD 'change_me';
GRANT manager_role TO elon_musk;

CREATE USER sheryl_sandberg WITH PASSWORD 'change_me';
GRANT manager_role TO sheryl_sandberg;

CREATE USER tim_cook WITH PASSWORD 'change_me';
GRANT manager_role TO tim_cook;

-- Sales Representatives
CREATE USER tony_stark WITH PASSWORD 'change_me';
GRANT sales_rep_role TO tony_stark;

CREATE USER peter_parker WITH PASSWORD 'change_me';
GRANT sales_rep_role TO peter_parker;

CREATE USER clark_kent WITH PASSWORD 'change_me';
GRANT sales_rep_role TO clark_kent;

-- Service Technicians
CREATE USER bruce_wayne WITH PASSWORD 'change_me';
GRANT service_tech_role TO bruce_wayne;

CREATE USER diana_prince WITH PASSWORD 'change_me';
GRANT service_tech_role TO diana_prince;

CREATE USER steve_rogers WITH PASSWORD 'change_me';
GRANT service_tech_role TO steve_rogers;


-- ================================
-- Revokes
-- ================================

-- Sales reps don’t update customer records directly
REVOKE UPDATE ON customers FROM sales_rep_role;

-- Service techs don't need access to sales reports
REVOKE SELECT ON top_customers FROM service_tech_role;

-- Service techs shouldn't be able to change the car prices
REVOKE UPDATE (price, status) ON cars FROM service_tech_role;


