---
marp: true
theme: gaia
paginate: true
header: "Convergence 2026 — Spring Boot Workshop"
footer: "GDGC VNR VJIET · neilghosh/springboot-workshop"
---

# Convergence 2026: Spring Boot & Enterprise Architecture Masterclass

**Event:** Convergence 2026, GDGC VNR VJIET  
**Duration:** 3 Hours (10 min Setup + 45 min Talk + 105 min Live Coding + 20 min Q&A) — talk expanded, hands-on pace unchanged (5 min trimmed via checkpoints)  
**Speaker / Co-Pilot:** Expert Java/Spring Boot Technical Architect  
**Pre-req for students:** Core Java + basic HTTP/JSON — no Spring experience needed

---

## Agenda

| Block | Time | Focus |
|-------|------|-------|
| Setup | 10 min | Verify JDK 17, clone, `.\mvnw.cmd spring-boot:run` → `[]` on H2 |
| **Talk — Concepts Before Code** | **45 min** | Slides 1–10 below (incl. why Spring Boot vs Node/Python/Go + why code in agent era) |
| Hands-on | 105 min | `step-0` → `step-3` (see Part 2) |
| Q&A | 20 min | Profiles, curl, Postgres, debugging |

> This deck is the **only theory you need before coding**. Every live-coding branch maps 1:1 to a slide.

---

## Part 1: Concepts Before Code (45 Minutes)

### Slide 1 — Welcome & The Modern Backend Landscape (2 min)
* **Title:** Building Production-Grade APIs with Spring Boot 3
* **Takeaway:** Spring Boot is the industry standard for enterprise Java — ecosystem, convention-over-configuration, enterprise readiness, 70%+ of Java microservices (JetBrains/JVM surveys).
* **Audience framing:** You know `public static void main` + JDBC — today we replace boilerplate with Spring idioms.
* **Workshop promise:** By `step-3-complete` you will have: `@RestController` → `@Service` → `JpaRepository` → H2/Postgres, with `curl` + tests green.

### Slide 1B — Why Spring Boot in 2026? (When Node / Python / Go Are "Easier") (4 min)
* **Every stack has a home — know when to pick it:**
  | Stack | Sweet spot | Trade-off at scale |
  |-------|------------|-------------------|
  | **Node (JS/TS)** | Fast MVP, full-stack JS, high I/O / chat apps | Dynamic typing → runtime bugs, single-thread, callback/promise complexity, weak transactions |
  | **Python** | AI/ML scripting, fastest to write | GIL, slow per-request, optional typing, fewer transactional guarantees, ORM less mature |
  | **Go** | Infra, CLI, high-concurrency services | Minimal enterprise ecosystem (no Spring Security/Batch/Data equivalent), verbose errors, small talent pool for large CRUD apps |
  | **Java + Spring Boot** | **Enterprise systems that must run 5–10 years with 50 engineers** | More boilerplate (we trade brevity for safety) |
* **Why Spring Boot wins for this workshop's domain (E-Commerce API that must be correct):**
  1. **Type safety + compile-time contracts** — `ProductRequestDTO` `@NotBlank`/`@Positive` caught before runtime vs JS `undefined is not a function`.
  2. **Ecosystem** — Security, Data JPA, Validation, Cloud, Batch, Kafka — one paradigm, not 20 npm/pip packages.
  3. **Performance + operations** — JVM JIT/G1GC, HikariCP, embedded Tomcat tuned for 1k+ rps; `java -jar` in Docker, no runtime install.
  4. **Team scale** — Explicit layers (`Controller→Service→Repository`), constructor DI, `@Transactional` make 200-student/50-engineer code reviewable.
* **Takeaway:** Prototype in Node/Python, tool in Go, **run the business in Spring Boot**. This workshop teaches the patterns that get you hired for the last bucket — and they transfer when you pick Go/Node later.

### Slide 1C — Why Learn to Code When Agents Write Code? (3 min)
* **The 2026 reality:** Agents (Cursor, Copilot, Muse) write the 80% — `ProductController` CRUD, DTOs, even `ProductRepository` — in seconds.
* **Why your coding skill matters more, not less:**
  1. **You own the 20% the agent gets wrong.** Hallucinated `DataSource` hard-wiring, missing `@Valid`, wrong `204 vs 200`, no `@Transactional` — only someone who understands IoC/DI/lifecycle catches it live.
  2. **Review > Generation.** Senior today = *spec → generate → verify → ship*. Verification needs fundamentals — exactly what Slides 2–9 give you. Without them you ship the agent's bug.
  3. **Agents need architecture.** They autocomplete files, they don't choose H2 vs Postgres, `ddl-auto=update` vs migrations, or `404` vs `400` — you do.
  4. **Durability:** Languages change (Node→Go→?), patterns don't — IoC, transactions, layered architecture, externalized config survive every hype cycle.
* **Workshop stance:** We code *without* an agent first so you can judge one after. In Q&A we will ask an agent to generate `ProductService` and you will spot the missing constructor injection — that's the skill.

> **Bridge:** "If you can explain why `ProductService` takes `ProductRepository` in its constructor and why `application-production.properties` is not hard-coded, you can pilot any agent tomorrow."

### Slide 2 — Spring vs Spring Boot: What Boot Gives You (5 min)
* **Spring (the framework):** IoC container, DI, AOP, transactions — powerful but verbose XML/Java config.
* **Spring Boot (opinionated layer on Spring):**

| Feature | What it does | Where you see it in this workshop |
|---------|--------------|-----------------------------------|
| **starter-parent + starters** | `spring-boot-starter-web/data-jpa/validation` pulls a curated, compatible set of deps — no version hell | `pom.xml:6` parent `3.2.5`, `pom.xml:20` three starters |
| **Auto-configuration** | `@SpringBootApplication` + `@ConditionalOnClass` auto-creates `DispatcherServlet`, `DataSource`, `JpaTransactionManager`, `Jackson` if on classpath | Delete `application.properties:11` driver — app still fails fast because condition not met |
| **Embedded server** | Tomcat/Jetty bundled — `java -jar target/*.jar` runs, no WAR deploy | `mvn spring-boot:run` / `java -jar` |
| **Externalized config** | `application.properties` → `application-production.properties` → env vars → `.env` (precedence order) | `application.properties:2` `spring.config.import=optional:file:.env[.properties]` |
| **Profiles** | One codebase, multiple `DataSource` beans via `spring.profiles.active` | `application.properties` (H2) vs `application-production.properties` (Postgres) |
| **Starters + Validation** | `jakarta.validation` on `ProductRequestDTO` → 400 auto | `dto/ProductRequestDTO.java:12` `@NotBlank` |

* **Demo cue (30 sec):** Comment out `spring-boot-starter-web` in `pom.xml` → `./mvnw spring-boot:run` fails: "Web server failed" — proves auto-configuration is conditional.

### Slide 3 — Spring Boot Features You Will Actually Use (7 min)
* **Auto-configuration deep dive (2 min):** `@SpringBootApplication = @Configuration + @EnableAutoConfiguration + @ComponentScan`. `spring.factories` → 150+ `*AutoConfiguration` classes. Example: `DataSourceAutoConfiguration` creates `HikariDataSource` when `spring.datasource.url` exists + `HikariCP` + `postgresql` on classpath.
* **Starter anatomy (1 min):** `spring-boot-starter-data-jpa` = `spring-data-jpa + hibernate-core + HikariCP + transactions`. You import one, you get the stack.
* **Externalized config + Profiles (2 min):** `application.properties` (default, H2, `ddl-auto=update`) ships safe defaults for 200 students. `application-production.properties` overrides only `datasource.url/username/password` + `PostgreSQLDialect` via `${POSTGRES_URL:...}` — 12-factor. `.env` auto-loaded, never committed (`-.gitignore:2`). Run: `.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=production"` vs `$env:SPRING_PROFILES_ACTIVE=production`.
* **Other Boot features mentioned (so students recognise them later):** Actuator (`/actuator/health` — add `spring-boot-starter-actuator` to enable), embedded Tomcat (port `8080` in `application.properties:4`), `spring.jpa.show-sql=true` for SQL logging, `H2 Console` at `/h2-console`.
* **What Boot is NOT:** No code generation — just conditional beans. You can exclude auto-config: `@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)`.

### Slide 4 — Inversion of Control: Who Creates the Objects? (5 min)
* **Without IoC (tight coupling):**
  ```java
  class ProductService {
      private final ProductRepository repo = new ProductRepository(new PostgresDataSource("jdbc:..."));
  }
  // Test needs real Postgres. New laptop needs DB install. Change DB = change code.
  ```
* **With IoC (Hollywood Principle — "Don't call us, we'll call you"):**
  ```java
  @Service
  class ProductService {
      private final ProductRepository repo;
      public ProductService(ProductRepository repo) { this.repo = repo; } // Spring injects
  }
  ```
* **IoC Container = `ApplicationContext` (BeanFactory + extras):** On startup: scans `com.convergence.ecommerce` → instantiates `@Component/@Service/@Repository/@RestController/@Entity` → wires dependencies → manages lifecycle (singleton by default) → destroys on shutdown.
* **ASCII:**
```text
  Your code                    Spring IoC Container (ApplicationContext)
  ─────────────────            ──────────────────────────────────────────
  new ProductService()   →     BeanDefinition → instantiate → inject deps → init → ready
                               (singleton, lazy=false)        ↑ @Transactional proxy added
```
* **Why it matters for workshop:** You never `new` a Service/Repository — container does it. That's why `ProductController` has an explicit constructor (`controller/ProductController.java:14`) not `new`.

### Slide 5 — Dependency Injection: The How (7 min)
* **Three injection styles — only one belongs in this workshop:**

| Style | Example | Verdict |
|-------|---------|---------|
| **Constructor** (chosen) | `public ProductService(ProductRepository r){this.r=r;}` | Immutable, required deps explicit, testable (`new Service(mockRepo)` in `ProductServiceTest.java:18`), `final` field |
| Setter | `setRepo(repo)` | Mutable, optional deps only |
| Field `@Autowired` | `@Autowired private Repo r;` | Hidden deps, reflection, hard to test, not used here |

* **Stereotypes:** `@Component` (generic bean), `@Service` (business logic + `@Transactional` in `service/ProductService.java:13`), `@Repository` (exception translation), `@RestController` (= `@Controller + @ResponseBody`), all are `@Component` → auto-detected by `@ComponentScan`.
* **`@Autowired` is optional on single constructor** since Spring 4.3 — we omit it intentionally (see `ProductService.java:19`).
* **Failure modes to demo (1 min):** Two beans of same type → `NoUniqueBeanDefinitionException` → fix with `@Qualifier` or `@Primary`. Circular constructor deps → `BeanCurrentlyInCreationException` → fix by refactoring.
* **Bean scope quick mention:** Default `singleton` (one per app), `prototype` (new per injection), `request/session` (web only) — workshop uses singleton throughout.

### Slide 6 — Bean Lifecycle (2 min — slot into DI)
```text
  Instantiate → Populate properties (DI) → BeanNameAware → @PostConstruct → InitializingBean → ready → @PreDestroy → destroy
```
* `ProductEntity` uses `@PrePersist` (JPA, not Spring) to set `createdAt` — different lifecycle, but shows "hook" idea.
* `@Transactional` is a proxy wrapped around the bean — reason you must call through Spring proxy, not `this.method()` internally.

### Slide 7 — The Request Lifecycle (DispatcherServlet & Layers) (3 min)
```text
[ curl / Frontend ] ── POST /api/products JSON ──►
[ DispatcherServlet (Front Controller) ]  ← auto-configured by Boot
   │  HandlerMapping → finds ProductController#createProduct
   ▼
[ ProductController @RestController ]  @Valid → 400 if fails, @RequestBody JSON → DTO
   ▼
[ ProductService @Service ]  @Transactional, mapToResponseDTO
   ▼
[ ProductRepository JpaRepository ]  Spring Data generates SELECT/INSERT at runtime
   ▼  HikariCP
[ H2 (mem) | PostgreSQL ]
   ▲  JSON 201 Created
   └────── Response
```
* Every `@GetMapping`/`@PostMapping` is a handler method — not a servlet you write.

### Slide 8 — Layered Architecture & Separation of Concerns (3 min)
1. **Controller (`@RestController`)** — HTTP only: mapping, status (`201 Created`, `404 Not Found`), validation (`@Valid`). No SQL, no business rules.
2. **Service (`@Service`)** — Business rules, transactions (`@Transactional` in `ProductService.java:23`), DTO↔Entity mapping (`mapToResponseDTO`). Decides "product not found" → exception → `GlobalExceptionHandler`.
3. **Repository (`JpaRepository`)** — Persistence only: `findAll()`, `findByCategory()` — no hand-written SQL. Hibernate + dialect (`H2Dialect` vs `PostgreSQLDialect`) hides DB differences.
* **Rule:** Controllers never touch `Entity`; Services never touch `HttpStatus` — keeps layers testable.

### Slide 9 — Why DI Makes This Workshop Work (Profile-Driven Injection) (5 min)
* **Hard-wiring failure:** `new PostgresDataSource(...)` in code → tests need Postgres, workshop needs 200 DB installs, profile switch = code change.
* **DI solution — container picks the bean:**
```text
              +--------------------------- Spring IoC Container ---------------------------+
              | Active Profile?                                                         |
              |   ├── default      ──► H2 DataSource (in-memory, Hikari, ddl-auto=update) |
              |   └── production   ──► Postgres DataSource (Hikari, env-var URL)          |
              +-------------------------------┬──────────────────────────────────────────+
                                             │  injected via constructor
                                             ▼
                                 [ ProductRepository / JPA ]
                                             ▼
                              [ ProductService — blind to DataSource ]
```
* **Payoff:**
  * **During live coding / `.\mvnw.cmd test`:** H2 injected — zero install, tests in <3 sec (`src/test/.../ProductControllerIntegrationTest.java` uses `@SpringBootTest` + `MockMvc` against H2).
  * **In real deploy:** `-Dspring-boot.run.profiles=production` injects `HikariDataSource` with `PostgreSQLDialect` — zero code change in `ProductService`.
  * **Proof:** `git checkout step-0-starter` (H2) → `curl []` works; `git checkout step-3-complete` + `production` → `\dt` shows `products` with same curl.

### Slide 10 — Before We Code: What You Will Type vs What Boot Does For You (1 min)
* **You type:** DTOs + Entity + Repository interface + Service + Controller + `application*.properties` (~200 LOC, verbose, no Lombok).
* **Boot creates:** Embedded Tomcat, `DispatcherServlet`, `ObjectMapper`, `Validator`, `DataSource`/`HikariCP`, `TransactionManager`, `ExceptionHandler` proxy.
* **Checklist on screen while coding:** `pom.xml` starters → `application.properties:11` H2 → `application-production.properties:3` env vars → `ProductService:19` constructor injection.

---

## Part 2: Hands-On Live Coding Roadmap (110 Minutes — pace unchanged)

| Step | Branch | What you add | Key file / concept | Time |
|------|--------|--------------|--------------------|------|
| 0 | `step-0-starter` | Maven, `EcommerceApplication.java`, H2 config | `pom.xml:17` `java.version=17` | 15 min |
| 1 | `step-1-rest-dto` | REST + DTOs + `jakarta.validation` | `dto/ProductRequestDTO.java` `@NotBlank` | 25 min |
| 2 | `step-2-service-db` | Entity + Repository + Service + DB | `model/ProductEntity.java` `@Entity`, `service/ProductService.java:37` `@Transactional` | 35 min |
| 3 | `step-3-complete` | Exception handler + tests + profiles | `exception/GlobalExceptionHandler.java` `@RestControllerAdvice`, `application-production.properties:3` | 35 min |

> Switch: `git checkout step-0-starter` (or `-1`, `-2`, `-3-complete`). Run each step with `.\mvnw.cmd spring-boot:run` (PowerShell: quoted `-D` — see README Troubleshooting).

---

## Appendix — Talk Backup Slides (use if time, else Q&A)
* **Spring Boot vs plain Spring — config size:** 50 lines XML → 3 lines `application.properties`.
* **Constructor injection test snippet:** `new ProductService(mockRepo)` in `ProductServiceTest.java` — proves DI makes unit tests DB-free.
* **`@Transactional` note:** Wraps method in proxy; `deleteProduct` checks `existsById` then `deleteById` — atomic.
