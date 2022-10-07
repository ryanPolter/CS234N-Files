/****** Select Statements for Lab  ******/
-- 1.  Select all of the customers who live in NY state.  Show id, name, city and state.  Sort in a reasonable way.

SELECT customerid, name, city, state FROM customers WHERE state = 'NY' ORDER BY state, city, name ;

-- 2.  Select all of the states that start with A .  Show both code and name.  Sort by name.

SELECT statecode, statename FROM states WHERE statename LIKE 'A%' ORDER BY statename;

-- 3.  Select all of the Products that have a price between 50 and 60 dollars.  Show code, description, price and quantity.  Sort by price.

SELECT productcode, description, unitprice, onhandquantity FROM products WHERE unitprice BETWEEN 50 AND 60 ORDER BY unitprice;

-- 4.  Get the value of the inventory that we have on hand for each product.  Show code, description, price, quantity and value.  Sort by value.

-- ? Is this asking for onhandquantity value or unit price value? if unit price then change the last var to ORDER BY unitprice
SELECT productcode, description, unitprice, onhandquantity FROM products ORDER BY onhandquantity;

-- 5.  Get me a list of the invoices.  Show invoice id, customerid, invoice month as a number, invoice month as a word, invoice year.  Sort by year and month number.

SELECT InvoiceID, CustomerID, month(InvoiceDate) AS monthnumber, monthname(InvoiceDate) AS month, year(InvoiceDate) AS yearnumber FROM invoices ORDER BY yearnumber, monthnumber;

-- 6.  Get me all of the information for the following products:  A4CS, ADC4, CS10

SELECT ProductCode, Description, UnitPrice, OnHandQuantity
	FROM products
    WHERE productcode IN ('A4CS', 'ADC4', 'CS10');

-- 7.  Add the name of the state to the result set from #1

SELECT customerid, name, city, state, statename 
	FROM customers INNER JOIN states ON customers.state = states.statecode
    WHERE state = 'NY' 
    ORDER BY state, city, name ;

-- 8.  Add the customer's name to the result set from #5

SELECT InvoiceID, invoices.CustomerID, month(InvoiceDate) AS monthnumber, monthname(InvoiceDate) AS month, year(InvoiceDate) AS yearnumber, customers.name 
	FROM invoices INNER JOIN customers
    ON invoices.customerid = customers.customerid
    ORDER BY yearnumber, monthnumber;

-- 9.  Get me a list of all of the products that have been ordered.  
--     Show all of the product information as well as the invoice id and the quantity ordered on each invoice.

--  "Not what products we have, but what products people are buying" "Not from invoices table, the table that has products thats been ordered
--  	are from the invoicelineitems table" "Joining product table to invoicelineitems table"

SELECT products.ProductCode, Description, products.UnitPrice, OnHandQuantity, InvoiceID, Quantity, invoicelineitems.UnitPrice
	FROM products INNER JOIN invoicelineitems
    ON products.ProductCode = invoicelineitems.ProductCode
    ORDER BY ProductCode;

-- 10. Get me a list of all of the invoices.  Show this invoiceid, customerid and invoicedate as well as the productcode, description, unitprice and quantity for each product ordered on the invoice.
--     You'll have more than one record for each invoice.

SELECT products.ProductCode, Description, products.UnitPrice, OnHandQuantity, Quantity,
		invoicelineitems.UnitPrice, invoices.InvoiceID, customerid, invoicedate
	FROM products INNER JOIN invoicelineitems
    ON products.ProductCode = invoicelineitems.ProductCode
    JOIN invoices
    ON invoices.invoiceid = invoicelineitems.invoiceid
    ORDER BY invoiceid;

-- 11. Add the customer's name and statecode to the results from #10.

SELECT products.ProductCode, Description, products.UnitPrice, OnHandQuantity, Quantity,
		invoicelineitems.UnitPrice, invoices.InvoiceID, invoices.customerid, invoicedate, customers.name, customers.state
	FROM products INNER JOIN invoicelineitems
    ON products.ProductCode = invoicelineitems.ProductCode
    JOIN invoices
    ON invoices.invoiceid = invoicelineitems.invoiceid
    JOIN customers
    ON customers.customerid = invoices.customerid
    ORDER BY invoiceid;
    
-- 12. Add the name of the state to the results from #11.

SELECT products.ProductCode, Description, products.UnitPrice, OnHandQuantity, Quantity,
		invoicelineitems.UnitPrice, invoices.InvoiceID, invoices.customerid, invoicedate, customers.name, customers.state, states.statename
	FROM products INNER JOIN invoicelineitems
    ON products.ProductCode = invoicelineitems.ProductCode
    JOIN invoices
    ON invoices.invoiceid = invoicelineitems.invoiceid
    JOIN customers
    ON customers.customerid = invoices.customerid
    JOIN states
    ON customers.state = states.StateCode
    ORDER BY invoiceid;
    
-- 13. How many products do we have?

-- *product code or '*' can be used in this case. If there were NULL fields for productcode in some of the products items they would not be counted and therefor '*' should be used, 
-- but a product cannot be entered w/o a product code so it's fine here
SELECT count(productcode) FROM products;

-- 14. How many customers do we have?
 
 SELECT count(*) FROM customers;
 
 -- SELECT state, count(*) FROM customers GROUP BY state; 	** This is an example talked about in the slides/screencasts, not actual question **
 
-- 15. What's the total value of all of the products we have on hand?

SELECT sum(unitprice * onhandquantity) AS totalValue FROM products;

-- 16. What's the total value of ALL of the products we have sold?  Use the itemtotal from invoicelineitems to do the calculation.

SELECT sum(unitprice * itemtotal) AS productsSoldValue FROM invoicelineitems;

-- 17. What's the total value of EACH products we have sold?  Use the itemtotal from invoicelineitems to do the calculation.
--     Show the productcode as well as the total for that product

SELECT productcode, sum(itemtotal) AS totalSold FROM invoicelineitems 
	GROUP BY productcode
    ORDER BY productcode;

-- 18.  Add the product description to #17. 	** join invoicelineitems and product table together; after adding description you must also add description to the GROUP BY clause

SELECT invoicelineitems.productcode, products.description, sum(itemtotal) AS totalSold
	FROM invoicelineitems JOIN products ON invoicelineitems.productcode = products.productcode
	GROUP BY invoicelineitems.productcode, products.description
    ORDER BY invoicelineitems.productcode;
    
-- 19.  How many orders (invoices) has each customer placed?  Show customerid, name and count.

SELECT customers.customerid, customers.name, count(invoicelineitems.invoiceid) AS invoiceCount 
	FROM customers JOIN invoicelineitems ON customers.customerid = invoicelineitems.invoiceid
    GROUP BY customers.customerid, invoicelineitems.invoiceid
    ORDER BY customers.customerid, customers.name;

-- 20.	List all customers, even if they don't have any orders.  Show customerid, name and count of orders (invoices).

SELECT customers.customerid, customers.name, count(invoicelineitems.invoiceid) AS invoiceCount 
	FROM customers LEFT JOIN invoicelineitems ON customers.customerid = invoicelineitems.invoiceid
    GROUP BY customers.customerid, invoicelineitems.invoiceid
    ORDER BY customers.customerid;
