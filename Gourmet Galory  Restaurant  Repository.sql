CREATE DATABASE RestaurantRepository;

USE RestaurantRepository;

-- Create Restaurant table
CREATE TABLE Restaurant (
    restaurant_id INT PRIMARY KEY,
    branch_name VARCHAR(255),
    address VARCHAR(255),
    phone_number VARCHAR(20)
);

INSERT INTO Restaurant
VALUES  
(1, 'Gourmet Galore Downtown', '123 Main St, City', '123-456-7890'),
(2, 'Gourmet Galore Uptown', '456 Oak St, City', '555-123-4567'),
(3, 'Gourmet Galore Suburbia', '789 Elm St, Suburb', '888-987-6543'),
(4, 'Gourmet Galore Heights', '101 Hillside Ave, City', '222-333-4444'),
(5, 'Gourmet Galore Seaside', '55 Beach Blvd, Coastal Town', '777-888-9999'),
(6, 'Gourmet Galore Downtown West', '789 Center St, City', '555-123-7890');

-- Create Menu table
CREATE TABLE Menu (
    dish_id INT PRIMARY KEY,
    restaurant_id INT,
    dish_name VARCHAR(255),
    description TEXT,
    price DECIMAL(10, 2),
    dish_type VARCHAR(50),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id)
);

INSERT INTO Menu 
VALUES
(1, 1, 'Caprese Salad', 'Fresh mozzarella, tomatoes, and basil', 8.99, 'appetizer'),
(2, 2, 'Creamy Mushroom Risotto', 'Arborio rice cooked with mushrooms', 14.99, 'main'),
(3, 2, 'Chocolate Fondue', 'Assorted fruits with chocolate dipping sauce', 10.99, 'dessert'),
(4, 3, 'Classic Pancakes', 'Fluffy pancakes served with maple syrup', 9.99, 'breakfast'),
(5, 4, 'Grilled Salmon', 'Fresh salmon fillet with lemon butter', 18.99, 'main'),
(6, 5, 'Fruit Parfait', 'Layers of yogurt, granola, and fresh fruits', 7.99, 'dessert');

-- Create Dietary_Restrictions table
CREATE TABLE Dietary_Restrictions (
    restriction_id INT PRIMARY KEY,
    dish_id INT,
    vegetarian BOOLEAN,
    vegan BOOLEAN,
    halal BOOLEAN,
    pescetarian BOOLEAN,
    gluten_free BOOLEAN,
    nut_free BOOLEAN,
    FOREIGN KEY (dish_id) REFERENCES Menu(dish_id)
);

INSERT INTO Dietary_Restrictions 
VALUES 
(1, 1, 1, 1, 0, 1, 1, 1),
(2, 2, 1, 0, 0, 1, 1, 1),
(3, 3, 1, 0, 0, 0, 1, 1),
(4, 4, 1, 0, 0, 1, 0, 1),
(5, 5, 0, 0, 0, 1, 1, 1),
(6, 6, 1, 0, 0, 0, 1, 1);

-- Selecting branch names and addresses from the Restaurant table
SELECT branch_name, address FROM Restaurant;

ALTER TABLE Restaurant
ADD COLUMN cuisine_type VARCHAR(50);

-- Update cuisine_type for specific rows
UPDATE Restaurant
SET cuisine_type = 'Italian'
WHERE branch_name IN ('Gourmet Galore Downtown', 'Gourmet Galore Uptown');

SET SQL_SAFE_UPDATES = 0;  

-- Display updated rows
SELECT * FROM Restaurant;

-- Calculating the average price of dishes in the Menu table
SELECT AVG(price) FROM Menu;

-- Joining Restaurant and Menu tables to get branch name and dish name
SELECT r.branch_name, m.dish_name FROM Restaurant r
JOIN Menu m ON r.restaurant_id = m.restaurant_id;

-- Selecting vegetarian dishes from the Menu table
SELECT dish_name, description FROM Menu WHERE dish_type = 'main' AND dish_id IN (
    SELECT dish_id FROM Dietary_Restrictions WHERE vegetarian = 1
);

-- Calculating the total price of all dishes in the Menu table
SELECT SUM(price) AS total_price FROM Menu;


-- Joining Restaurant and Menu tables to get branch name and dish count
SELECT r.branch_name, COUNT(m.dish_id) AS dish_count FROM Restaurant r
LEFT JOIN Menu m ON r.restaurant_id = m.restaurant_id
GROUP BY r.branch_name;

-- Selecting most expensive dish from Menu table
SELECT m.dish_name, m.price
FROM Menu m
ORDER BY m.price DESC
LIMIT 1;

-- Selecting least expensive dish from Menu table
SELECT m.dish_name, m.price
FROM Menu m
ORDER BY m.price
LIMIT 1;

-- Count of dishes with specific dietary restrictions
SELECT 
    SUM(vegetarian) AS vegetarian_dishes,
    SUM(vegan) AS vegan_dishes,
    SUM(halal) AS halal_dishes,
    SUM(pescetarian) AS pescetarian_dishes,
    SUM(gluten_free) AS gluten_free_dishes,
    SUM(nut_free) AS nut_free_dishes
FROM Dietary_Restrictions;

-- Total Number of Dishes with Dietary Restrictions
 SELECT COUNT(*) AS total_dishes_with_restrictions
FROM Dietary_Restrictions
WHERE vegetarian = 1 OR vegan = 1 OR halal = 1 OR pescetarian = 1 OR gluten_free = 1 OR nut_free = 1;

-- Average Number of Dietary Restrictions per Dish
SELECT AVG(vegetarian + vegan + halal + pescetarian + gluten_free + nut_free) AS avg_restrictions_per_dish
FROM Dietary_Restrictions;

-- Dishes with the Most Dietary Restrictions 
SELECT dish_id,
(vegetarian + vegan + halal + pescetarian + gluten_free + nut_free) AS total_restrictions
FROM Dietary_Restrictions
ORDER BY total_restrictions DESC
LIMIT 1;

-- Dishes with the Fewest Dietary Restrictions
SELECT dish_id,
(vegetarian + vegan + halal + pescetarian + gluten_free + nut_free) AS total_restrictions
FROM Dietary_Restrictions
ORDER BY total_restrictions ASC
LIMIT 1;




