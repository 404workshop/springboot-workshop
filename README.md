# Convergence 2026: Spring Boot 3 E-Commerce API Workshop

Welcome to the **Convergence 2026** Spring Boot Masterclass hosted by **GDGC VNR VJIET**. This repository contains the complete slide deck, step-by-step hands-on checkpoints, and production-grade source code for building a robust E-Commerce REST API.

---

## ⏱️ Workshop Schedule (3 Hours)
* **Registration & Setup:** 15 min
* **Intro & Architecture Presentation:** 30 min (`PRESENTATION.md`)
* **Hands-on Live Coding (CRUD, Services, DB):** 2 hours
* **Q&A & Wrap-up:** 15 min

---

## 🏛️ Architecture Overview

```text
[ Client (Postman / Frontend) ]
              │
              ▼  HTTP Request (JSON)
[ DispatcherServlet (Front Controller) ]
              │
              ▼
[ ProductController (@RestController) ] ── (DTO Validation)
              │
              ▼
[ ProductService (@Service) ] ────────── (Business Logic & Transactions)
              │
              ▼
[ ProductRepository (Spring Data JPA) ] ── (ORM / Hibernate)
              │
              ▼
[ PostgreSQL / H2 In-Memory DB ]
```

---

## 🚀 Getting Started & Prerequisites (Terminal-First)

Before starting the workshop, ensure you have the bare minimum tools installed:

1. **Oracle JDK 17+**: 
   * Download and install [Oracle JDK 17](https://www.oracle.com/java/technologies/downloads/#java17).
   * Verify installation: `java -version`
2. **Apache Maven (3.8+)**: 
   * Download from [Maven Official Site](https://maven.apache.org/download.cgi).
   * Verify installation: `mvn -version`
3. **Editor (VS Code / Any Text Editor)**: 
   * Open the project folder in VS Code or your preferred terminal editor. No mandatory extensions required—just plain Java files and Maven.
4. **API Testing Tool**: 
   * Postman or `curl`.

### Running & Debugging from Terminal

```bash
# Navigate to project root
cd springboot-workshop

# 1. Run the application normally
mvn spring-boot:run

# 2. Run with remote debugging enabled (Suspended on startup on port 5005)
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005"
```

The application will start on port `8080`. By default, it uses an in-memory **H2 Database** with the H2 Console available at:
`http://localhost:8080/h2-console` (JDBC URL: `jdbc:h2:mem:ecommercedb`, Username: `sa`, Password: ``).

---

## 🌿 Step-by-Step Checkpoints (Git Branches)

Follow along during the live coding session by switching branches:

* **`step-0-starter`**: Initial project setup, dependencies, and configuration.
  ```bash
  git checkout step-0-starter
  ```
* **`step-1-rest-dto`**: REST controllers, DTO request/response records, and Jakarta Bean Validation.
  ```bash
  git checkout step-1-rest-dto
  ```
* **`step-2-service-db`**: JPA Entities, Spring Data Repositories, Service layer, and database integration.
  ```bash
  git checkout step-2-service-db
  ```
* **`step-3-complete`**: Global Exception Handling, polished error responses, and complete CRUD implementation.
  ```bash
  git checkout step-3-complete
  ```

---

## 📬 Postman Collection

Import the included Postman collection to test all API endpoints:
* **File Location:** `postman/Convergence-2026-ECommerce-API.postman_collection.json`

### Endpoints Summary
| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/products` | Retrieve all products |
| `GET` | `/api/products/{id}` | Retrieve product by ID |
| `POST` | `/api/products` | Create a new product (with validation) |
| `PUT` | `/api/products/{id}` | Update an existing product |
| `DELETE` | `/api/products/{id}` | Delete a product by ID |
