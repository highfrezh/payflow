# PayFlow Requirements Specification

**Version:** 1.0  
**Status:** Baseline confirmed  
**Project:** Simulated Digital Wallet and Payment Platform  
**Currency:** Nigerian naira (NGN)

## 1. Project Overview

PayFlow is a backend digital wallet and payment platform built with C# and ASP.NET Core Web API.

It allows authenticated users to create a wallet, check their balance, transfer simulated funds to other PayFlow wallets, and view transaction history.

The project demonstrates secure backend development, Clean Architecture, financial transaction integrity, system design, scalability, reliability, and observability.

**Scope limitation:** PayFlow initially handles simulated funds only. It does not process real money or integrate with banks or external payment providers.

## 2. Functional Requirements

| ID | Requirement | Description |
|---|---|---|
| FR-01 | Authentication | Authenticate users using ASP.NET Core Identity and JWT bearer tokens. |
| FR-02 | Wallet creation | Allow an authenticated user to create one wallet initially. |
| FR-03 | Balance inquiry | Allow users to retrieve their own wallet balance. |
| FR-04 | Simulated deposits | Allow deposits only through a restricted, authorized test/admin operation. |
| FR-05 | Wallet transfers | Support transfers between PayFlow wallets only. |
| FR-06 | Transaction history | Allow users to view transaction history associated with their own wallets. |
| FR-07 | Input validation | Reject invalid amounts, malformed requests, and invalid wallet references. |
| FR-08 | Transfer integrity | Ensure a transfer debits the sender and credits the recipient atomically. |
| FR-09 | Idempotency | Prevent duplicate execution when supported financial requests are retried with the same idempotency key. |
| FR-10 | Authorization | Prevent users from accessing wallets or administrative operations they are not authorized to use. |

## 3. Non-Functional Requirements

### 3.1 Correctness and consistency
- Prevent overspending during concurrent transfers.
- Do not permit negative balances through invalid or concurrent operations.
- Ensure failed transfers do not leave partial balance changes.
- Keep transaction records consistent with committed financial operations.

### 3.2 Security
- Protect wallet operations with authentication and authorization.
- Store credentials securely.
- Protect JWT signing keys and other secrets.
- Restrict simulated deposits to authorized test/admin identities.
- Avoid logging passwords, tokens, or other sensitive authentication information.

### 3.3 Reliability
- Persist committed transactions.
- Handle failed requests and retries safely.
- Provide health checks and diagnostic logging.
- Document backup and recovery strategies as the system evolves.

### 3.4 Performance
- Estimate average and peak requests per second.
- Estimate transaction volume, storage growth, and network bandwidth.
- Define response-time targets before performance testing.
- Compare load-test measurements against documented assumptions.

### 3.5 Scalability
- Design the API to support multiple instances.
- Evaluate caching, database scaling, and asynchronous processing.
- Introduce additional infrastructure when justified by requirements or experiments.

### 3.6 Observability
- Implement structured application logging.
- Measure request latency, throughput, and error rates.
- Monitor database performance and relevant infrastructure health.
- Provide enough information to investigate failures.

### 3.7 Maintainability and testability
- Separate business rules, application use cases, infrastructure, and API endpoints.
- Use automated unit and integration tests.
- Document important architectural decisions and trade-offs.

## 4. Technology Choices

| Technology | Purpose | Initial status |
|---|---|---|
| C# | Primary programming language | Planned for initial implementation |
| ASP.NET Core Web API | HTTP API | Planned for initial implementation |
| ASP.NET Core Identity | User management | Planned for initial implementation |
| JWT bearer tokens | API authentication | Planned for initial implementation |
| PostgreSQL | Persistent wallet and transaction data | Planned for initial implementation |
| Entity Framework Core | Database access | Proposed |
| Redis | Caching and distributed rate limiting | Future milestone |
| Message broker | Asynchronous processing | Future milestone |
| Git and GitHub | Version control and documentation | Project tooling |
| draw.io | Architecture diagrams | Project tooling |

## 5. Project Scope

### 5.1 Initial implementation
- User registration and authentication.
- One wallet per user.
- Balance inquiry.
- Restricted simulated deposits.
- Wallet-to-wallet transfers.
- Transaction history.
- Database persistence.
- Transfer correctness and idempotency.
- Automated testing and basic observability.

### 5.2 Future milestones
- Redis caching and distributed rate limiting.
- Message queues and asynchronous processing.
- Multiple API instances and load balancing.
- Database replication and scaling experiments.
- Failure detection, recovery, and data-centre outage simulations.
- Capacity estimation and load testing.
- Deployment automation and expanded monitoring.

### 5.3 Exclusions
- Real deposits and withdrawals.
- Real bank or payment-provider integration.
- Actual custody of customer funds.
- Production financial settlement and regulatory operations.

## 6. Workload and Capacity Planning

PayFlow will be designed around a moderate hypothetical workload.

The following values still need to be established through explicit assumptions and calculations:

- Registered users and monthly active users.
- Average and peak requests per second.
- Read-to-write request ratio.
- Daily deposits and transfers.
- Average transaction record size.
- Database storage growth.
- Network bandwidth.
- Expected concurrency and database connection demand.

These calculations will inform the High-Level Architecture. Estimates will be distinguished from measured results.

## 7. Architecture Principles

1. PostgreSQL is the authoritative source for wallet balances and financial transactions.
2. Transfers must use database transactions to protect financial correctness.
3. Cached data must not replace authoritative checks required to approve transfers.
4. Application instances should not depend on local in-memory state for shared coordination.
5. Asynchronous processing must not compromise the correctness of committed transfers.
6. Additional infrastructure must have a documented purpose and trade-off.
7. Planned, implemented, and tested capabilities must be identified accurately in project documentation.

## 8. Acceptance Criteria

The initial implementation must demonstrate that:

- Protected operations reject unauthenticated requests.
- Users cannot access other users' wallets without authorization.
- Only authorized test/admin identities can initiate simulated deposits.
- Invalid transfers leave balances unchanged.
- Concurrent transfers cannot overspend a wallet.
- A transfer cannot commit only its debit or only its credit.
- Retrying a supported operation with the same idempotency key does not execute it twice.
- Committed financial records persist across application restarts.
- Automated tests verify critical business rules.
- Performance results are reported only after actual measurements.

## 9. Confirmed Decisions

- Authentication uses ASP.NET Core Identity and JWT bearer tokens.
- Each user has one wallet initially.
- Transfers are limited to PayFlow wallets.
- API consumers are the initial clients; web or mobile clients may be added later.
- Simulated deposits use a restricted test/admin operation.
- Email notifications are a future integration.
- PostgreSQL is the planned primary database.
- Clean Architecture is the chosen code organization approach.
- The workload will be estimated using explicit moderate-load assumptions.

## 10. Remaining Decisions and Assumptions

The following details will be finalized during detailed design:

- JWT expiry, refresh-token strategy, and account recovery.
- The initial financial data model, including whether to use a ledger-based model.
- Transfer concurrency control and database constraints.
- Numerical workload and response-time targets.
- Availability objectives and recovery targets.
- Deployment environment and specific load-balancing technology.
- Message broker selection.
- Whether an external identity provider will ever be integrated.

## 11. Related Documentation

The following documents will be added as the project progresses:

- System Context Diagram.
- Back-of-the-Envelope Estimation.
- High-Level Architecture.
- Clean Architecture Diagram.
- Wallet Transfer Sequence Diagram.
- Data Model and Transaction Design.
- Architecture Decision Records.
- Testing and Performance Results.
