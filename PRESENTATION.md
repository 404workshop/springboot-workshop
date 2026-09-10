# Convergence 2026: Spring Boot & Enterprise Architecture Masterclass

**Event:** Convergence 2026, GDGC VNR VJIET  
**Duration:** 3 Hours (30 min Talk + 2 Hours Live Coding + 15 min Q&A + 15 min Setup)  
**Speaker / Co-Pilot:** Expert Java/Spring Boot Technical Architect  

---

## Part 1: Architecture Presentation (30 Minutes)

### Slide 1: Welcome & The Modern Backend Landscape
* **Title:** Building Production-Grade Microservices with Spring Boot 3
* **Key Takeaway:** Why Spring Boot remains the industry standard for enterprise Java backend development (ecosystem, convention over configuration, robust security, enterprise readiness).
* **Target Audience:** Engineering students transitioning from academic Java to professional backend engineering.

### Slide 2: The Spring IoC Container & Dependency Injection (The Core Mental Model)
* **Concept:** Inversion of Control (IoC) and Dependency Injection (DI).
* **Analogy:** Instead of your class calling `new MyService()`, the Spring IoC Container (ApplicationContext) manufactures, wires, and manages object lifecycles.
* **ASCII Architecture Diagram:**
```text
 +-------------------------------------------------------+
 |                 Spring IoC Container                  |
 |                   (ApplicationContext)                |
 |                                                       |
 |   [ProductController] --------( @Autowired )--------> |
 |          |                                            |
 |          v                                            |
 |   [ProductService]   --------( @Autowired )-------->  |
 |          |                                            |
 |          v                                            |
 |   [ProductRepository]                                 |
 +-------------------------------------------------------+
```

### Slide 3: The Request Lifecycle (DispatcherServlet & Layers)
* **Concept:** How an HTTP request travels from the client (Postman/Frontend) through Spring's architecture.
* **ASCII Lifecycle Flow:**
```text
[ Client (Postman) ] 
       │
       ▼  HTTP POST /api/products
[ DispatcherServlet (Front Controller) ]
       │
       ▼  Mapping handler
[ ProductController (@RestController) ]
       │
       ▼  Validation & DTO mapping
[ ProductService (@Service) - Business Logic ]
       │
       ▼  JPA / Hibernate Entity conversion
[ ProductRepository (Spring Data JPA) ]
       │
       ▼  SQL over JDBC / HikariCP
[ PostgreSQL Database ]
```

### Slide 4: Layered Architecture & Separation of Concerns
1. **Controller Layer (`@RestController`)**: Handles HTTP protocol details, request mapping, validation (`@Valid`), and HTTP status codes (`201 Created`, `400 Bad Request`, `404 Not Found`).
2. **Service Layer (`@Service`)**: Encapsulates core business logic, transaction boundaries (`@Transactional`), and data transformation (DTO ↔ Entity).
3. **Repository Layer (`JpaRepository`)**: Manages database persistence without writing boilerplate SQL queries.

### Slide 5: Why Dependency Injection? (Hard-Wiring vs Profile-Driven DI)
* **The Problem with Hard-Wiring (`new`):**
  If `ProductService` or `ProductRepository` hard-wired `new PostgresDataSource(...)`, your code would be tightly coupled to PostgreSQL. Your automated tests would fail without a running database, and running on a peer's laptop would require full database setup.
* **The DI Solution (Profile-Based Injection):**
  The Spring IoC container manufactures and injects the appropriate `DataSource` bean at runtime based on the active profile:

```text
               +-------------------------------------------+
               |           Spring IoC Container            |
               |                                           |
               |   Active Profile?                         |
               |      ├── default  ──> [ H2 DataSource ]   |
               |      └── production ─> [ Postgres DS ]   |
               +---------------------+---------------------+
                                     │
                                     ▼ (Injected via DI)
                       [ ProductRepository / JPA ]
                                     │
                                     ▼
                        [ ProductService (Blind) ]
```

* **Why this is powerful for TDD & Production:**
  * **During Tests / Local Dev (`default`):** Spring injects the fast, in-memory H2 `DataSource`. Zero installation required, tests run in milliseconds.
  * **In Production (`production`):** Pass `-Dspring-boot.run.profiles=production` to inject the high-performance PostgreSQL `HikariDataSource`.
  * **Zero Code Changes:** Not a single line of Java business code in `ProductService` changes between development and production!

---

## Part 2: Hands-On Live Coding Roadmap (2 Hours)
* **Step 0:** Starter Boilerplate (`step-0-starter`)
* **Step 1:** REST Controller, DTOs & Validation (`step-1-rest-dto`)
* **Step 2:** Service Layer, Persistence & Database (`step-2-service-db`)
* **Step 3:** Complete Application, Exception Handling & Postman Testing (`step-3-complete`)
