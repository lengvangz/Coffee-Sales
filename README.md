# ☕️ Coffee Sales
<img src="https://github.com/lengvangz/images/blob/main/coffee%20sales.png" alt="Image" width="75%" height="75%">



## 📖 Table of Contents
- [Situation](#Situation)
- [Task](#Task)
- [Actions](#Actions)

***

## ‼️ Situation
Yaroslav got married recently. A year into their marriage, his wife shared the exciting news that she was pregnant. Motivated by this, Yaroslav decided to invest in a coffee vending machine as a source of income. He also began collecting data to help maximize his earnings.

***

## 📋 Task
Yaroslav wants to analyze the data to answer some key questions about his business, including time series trends, sales predictions for the next day, week, and month, and customer purchase behaviors. 



***

## 🏃 Action 

### Dashboard
<img src="https://github.com/lengvangz/images/blob/main/coffee%20sales%20dashboard.png" alt="Image" width="50%" height="50%">

**1. Identify peak purchasing days to plan marketing efforts:**

````sql
SELECT
	TO_CHAR(date, 'day') AS day_of_week,
	COUNT(*) AS num_purchase
FROM
	coffee_sales.sales
GROUP BY
	day_of_week
ORDER BY 
	num_purchase desc
LIMIT 3

````

#### Answer:
| day_of_week | num_purchase |
| ----------- | ----------- |
| tuesday           | 432          |
| monday           | 383          |
| thursday           | 374          |

- On Tuesdays, 432 coffes were sold. 
- On Mondays, 383 coffes were sold. 
- On Thursdays, 374 coffes were sold. 

***

**2. What is the most popular coffee?**

````sql
SELECT
	coffee_name,
	COUNT(*)
FROM
	coffee_sales.sales
GROUP BY 
	coffee_name
ORDER BY
	COUNT(*) DESC
LIMIT 1

````

#### Answer:
| coffee_name | count |
| ----------- | ----------- |
| Americano with Milk           | 621           |


- Americano with Milk is the most popular coffee with 621 purchases

***

**3. Analyze total sales trend over time**

````sql
SELECT 
	EXTRACT(MONTH FROM date) AS num_month,
	SUM(money) AS total_sales_in_Ukrainian hryvnias
FROM 
	coffee_sales.sales
GROUP BY 
	num_month
ORDER BY 
	num_month
````

#### Answer:
| num_month | total_sales_in_Ukrainian_hryvnias  |  
| ----------- | ----------- | 
| 3           | 7050.20  |        
| 4           | 6720.56  |         
| 5           | 9063.42  |         
| 6	      | 7758.76  | 	   
| 7	      | 6915.91  | 	   
| 8           | 7613.84  |        
| 9           | 9988.64  |         
| 10           | 13891.16  |         
| 11	      | 8590.54  | 	   
| 12	      | 6053.04 | 

- Customer A first order was sushi and curry.
- Customer B first order was curry.
- Customer C first order was ramen.

***

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

````sql
SELECT 
	m.product_name,
	COUNT(s.product_id) AS num_purchased
FROM 
	menu m 
INNER JOIN sales s 
	ON m.product_id = s.product_id
GROUP BY 
	m.product_name
ORDER BY 
	num_purchased DESC
LIMIT 1;
````

#### Answer:
| product_name | num_purchased |
| ------------ | ------------- | 
| ramen        | 8             | 


- The most popular item on the menu is ramen, which was ordered 8 times.

***

**5. Which item was the most popular for each customer?**

````sql
SELECT
	s.customer_id,
	m.product_name,
	COUNT(s.product_id) AS num_purchase
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
GROUP BY
	s.customer_id, m.product_name
ORDER BY
	s.customer_id ASC, num_purchase DESC;
````

#### Answer:
| customer_id | product_name  | num_purchase | 
| ----------- | ------------- | ------------ |
| A           | ramen  	      | 3            |
| A           | curry         | 2            |
| A           | sushi         | 1            |
| B	      | sushi         | 2	     |
| B	      | curry         | 2	     |
| B	      | ramen         | 2	     |
| C	      | ramen         | 3	     |

- Customer A most popular item was ramen.
- Customer B most popular item was both sushi and curry.
- Customer C most popular item was ramen.

***

**6. Which item was purchased first by the customer after they became a member?**

````sql
SELECT 
	s.customer_id,
	s.order_date,
	m.product_name
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
INNER JOIN members mem
	ON s.customer_id = mem.customer_id
WHERE 
	s.order_date > join_date
ORDER BY
	s.customer_id , order_date;
````

#### Answer:
| customer_id | order_date  | product_name | 
| ----------- | ----------- | ------------ |
| A           | 2021-01-10  | ramen        |
| A           | 2021-01-11  | ramen        |
| A	      | 2021-01-11  | ramen	   |
| B	      | 2021-01-11  | sushi	   |
| B	      | 2021-01-16  | ramen	   |
| B	      | 2021-02-01  | ramen	   |

- The first item Customer A purchased after becoming a member was ramen.
- The first item Customer B purchased after becoming a member was sushi.

***

**7. Which item was purchased just before the customer became a member?**

````sql
SELECT 
	s.customer_id,
	s.order_date,
	m.product_name
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
INNER JOIN members mem
	ON s.customer_id = mem.customer_id
WHERE 
	s.order_date < join_date
ORDER BY
	s.customer_id , order_date desc;
````

#### Answer:
| customer_id | order_date  | product_name | 
| ----------- | ----------- | ------------ |
| A           | 2021-01-01  | sushi        |
| A           | 2021-01-01  | curry        |
| B	      | 2021-01-04  | sushi	   |
| B	      | 2021-01-02  | curry	   |
| B	      | 2021-02-01  | curry	   |

- The item Customer A purchased before becoming a member was sushi and curry.
- The item Customer B purchased before becoming a member was sushi.

***

**8. What is the total items and amount spent for each member before they became a member**

````sql
SELECT
	s.customer_id,
	COUNT(s.product_id) AS num_items,
	SUM(m.price) AS total_amount_spent
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
INNER JOIN members mem
	ON s.customer_id = mem.customer_id
WHERE 
	order_date < join_date
GROUP BY
	s.customer_id
ORDER BY
	s.customer_id;
````

#### Answer:
| customer_id | num_items | total_amount_spent | 
| ----------- | --------- | ------------------ |
| A           | 2         | 25                 |
| B           | 3         | 40                 |


- Customer A purchased a total of 2 items, spending $25 in total.
- Customer B purchased a total of 3 items, spending $40 in total.

***

**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

````sql
SELECT
	s.customer_id,
	SUM(CASE
		WHEN m.product_name = 'sushi' THEN price*20
		ELSE mprice*10
	END) AS total_points
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
GROUP BY 
	s.customer_id
ORDER BY
	s.customer_id;
````

#### Answer:
| customer_id | total_point |  
| ----------- | ----------- | 
| A           | 860         | 
| B           | 940         |
| C           | 360         | 


- Customer A would have 860 points.
- Customer B would have 941 points.
- Customer C would have 360 points.

***

