# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---

### 1. **gold.dim_customers**
- **Purpose:** Stores customer details enriched with geographic and transactional data.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|--------------|-----------------------------------------------------------------------------------------------|
| customer_id      | INT           | Unique numerical identifier assigned to each customer.                                        |
| full_name       | NVARCHAR(255) | The concatenated full name of the customer.                                                  |
| email           | NVARCHAR(255) | Customer email address for communication.                                                     |
| city           | NVARCHAR(100) | The city of residence for the customer.                                                       |
| country_name    | NVARCHAR(100) | The country of residence for the customer (e.g., 'USA', 'Canada').                           |
| address_status  | NVARCHAR(50)  | The status of the customer’s address (e.g., 'Active', 'Inactive').                           |

---

### 2. **gold.dim_books**
- **Purpose:** Provides information about books and their metadata.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|--------------|-----------------------------------------------------------------------------------------------|
| book_id         | INT           | Unique identifier assigned to each book.                                                     |
| title           | NVARCHAR(255) | The official title of the book.                                                              |
| isbn13          | NVARCHAR(13)  | The 13-digit International Standard Book Number (ISBN) for the book.                        |
| author_name     | NVARCHAR(255) | The full name of the book’s author.                                                          |
| language_name   | NVARCHAR(100) | The language in which the book is published.                                                 |
| num_pages       | INT           | Total number of pages in the book.                                                           |
| publication_date | DATE         | The official publication date of the book.                                                   |
| publisher_name  | NVARCHAR(255) | The name of the publisher responsible for printing the book.                                 |

---

### 3. **gold.dim_orders**
- **Purpose:** Stores order-level information for tracking transactions.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|--------------|-----------------------------------------------------------------------------------------------|
| order_id        | INT           | Unique identifier assigned to each order.                                                    |
| order_date      | DATE          | The date when the order was placed.                                                          |
| customer_id     | INT           | The customer who placed the order.                                                           |
| status_value    | NVARCHAR(50)  | The current status of the order (e.g., 'Shipped', 'Delivered').                              |
| shipping_method | NVARCHAR(100) | The shipping method used for delivery (e.g., 'Standard', 'Express').                        |

---

### 4. **gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|--------------|-----------------------------------------------------------------------------------------------|
| order_id       | INT           | Unique identifier for each sales order.                                                      |
| order_date     | DATE          | The date when the order was placed.                                                          |
| customer_id    | INT           | The customer associated with the order.                                                      |
| book_id        | INT           | The book associated with the sale.                                                           |
| price         | DECIMAL(10,2)  | The price of the book at the time of sale.                                                  |
| status_id      | INT           | The status identifier associated with the order.                                            |
| status_value   | NVARCHAR(50)  | The description of the order status (e.g., 'Completed', 'Pending').                         |
| shipping_method | NVARCHAR(100) | The method used for shipping the order.                                                     |
| shipping_cost  | DECIMAL(10,2)  | The cost of shipping for the order.                                                         |

---

## **Conclusion**
This **Gold Layer Data Catalog** provides a structured representation of business-critical data for **BI tools, dashboards, and analytical reporting**. It ensures **clean, validated, and optimized** data, supporting key **sales, customer, and book performance insights**.

