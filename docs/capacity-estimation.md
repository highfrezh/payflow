# PayFlow Capacity Estimation

## 1. Purpose

This document records the initial back-of-the-envelope capacity estimates for PayFlow, a simulated digital wallet and payment platform built with C# and ASP.NET Core Web API.

The purpose is to estimate request traffic, peak load, financial transaction volume, and raw transaction-record storage. These estimates will help inform initial architecture decisions and future scalability experiments.

**Status:** Initial planning estimates  
**Important:** All figures are hypothetical assumptions. They are not measured production results.

## 2. Workload Assumptions

| Metric | Assumption |
|---|---:|
| Registered users | 100,000 |
| Daily active users | 20,000 |
| Average API requests per active user per day | 50 |
| Financial transactions per day | 10,000 |
| Average stored transaction-record size | 1 KB |
| Seconds per day | 86,400 |
| Days per year | 365 |
| Assumed peak traffic multiplier | 3 |

These values provide a consistent baseline for learning and planning. They must be revisited when actual application traffic and performance measurements become available.

## 3. API Traffic Estimation

### 3.1 Daily API Requests

Formula:

Daily API requests = Daily active users × Average requests per active user per day

Calculation:

20,000 × 50 = 1,000,000 requests per day

**Estimated daily API requests: 1 million.**

### 3.2 Average Requests Per Second

Formula:

Average RPS = Daily API requests ÷ Seconds per day

Calculation:

1,000,000 ÷ 86,400 ≈ 11.57

**Estimated average traffic: approximately 11.57 requests per second.**

RPS means requests per second. QPS, or queries per second, is another commonly used term for request or query throughput, although its precise meaning depends on the system being measured.

### 3.3 Peak Requests Per Second

Traffic is not distributed evenly throughout the day. For initial planning, this exercise assumes that peak traffic is three times average traffic.

Formula:

Estimated peak RPS = Average RPS × Peak multiplier

Calculation:

11.57 × 3 ≈ 34.72

**Estimated peak traffic: approximately 35 requests per second.**

The multiplier is an assumption, not a universal rule. Actual peak traffic must eventually be established through monitoring or representative traffic measurements.

## 4. Financial Transaction Volume

API requests and financial transactions are different metrics. A user can make several API requests without initiating a financial transaction.

Assumption: PayFlow processes 10,000 financial transactions per day.

### 4.1 Annual Transaction Volume

Formula:

Annual transactions = Daily transactions × Days per year

Calculation:

10,000 × 365 = 3,650,000

**Estimated annual financial transaction volume: 3.65 million transactions.**

This assumes constant daily transaction volume throughout the year.

## 5. Transaction-Record Storage Estimation

Assumption: Each stored transaction record averages 1 KB.

This is a simplified raw-data estimate. It excludes indexes, database row overhead, additional records, logs, and backups.

### 5.1 Daily Storage

Formula:

Daily storage = Daily transactions × Average record size

Calculation:

10,000 × 1 KB = 10,000 KB

Using decimal units, this is approximately 10 MB per day.

### 5.2 Annual Storage

Formula:

Annual raw storage = Daily storage × Days per year

Calculation:

10 MB × 365 = 3,650 MB

**Estimated annual raw transaction-record storage: approximately 3.65 GB.**

This is not the total PostgreSQL disk-space requirement. The actual database will require additional space for indexes, metadata, wallet records, idempotency records, audit data, and other application data. Backup capacity must also be planned separately.

## 6. Initial Architecture Implications

### API Layer

Begin with a straightforward ASP.NET Core Web API deployment. Validate throughput and latency using load tests before deciding whether multiple API instances are necessary.

### Database

Use PostgreSQL as the authoritative source for wallet balances and financial transactions. Add indexes for common queries, particularly transaction-history lookups, and measure query performance.

### Transfer Correctness

Financial correctness is required regardless of traffic volume. Transfers must use atomic database operations and suitable concurrency controls to prevent overspending and inconsistent debit or credit operations.

### Future Scaling

As the application evolves, investigate the need for:

- Multiple API instances and a load balancer.
- Shared rate limiting and appropriate caching.
- Database performance tuning and, when justified, replication.
- Asynchronous processing for suitable background tasks.
- Monitoring, alerting, and recovery procedures.

These are future design considerations, not claims that the infrastructure has already been implemented.

## 7. Limitations

These calculations provide an initial estimate, not a performance guarantee.

- The number of requests per user is hypothetical.
- Peak traffic may differ significantly from the assumed multiplier.
- API requests have different processing costs.
- Transaction-record size is an approximation.
- Storage estimates exclude database overhead and backups.
- Request throughput alone cannot determine server count, latency, or database capacity.

The estimates should be refined as requirements become clearer and replaced or validated with measured results during performance testing.

## 8. Summary

| Metric | Initial estimate |
|---|---:|
| Daily API requests | 1,000,000 |
| Average API request rate | 11.57 requests/second |
| Estimated peak request rate | 34.72 requests/second |
| Daily financial transactions | 10,000 |
| Annual financial transactions | 3,650,000 |
| Daily raw transaction-record storage | 10 MB |
| Annual raw transaction-record storage | 3.65 GB |

## 9. Related Documentation

- [Project README](../README.md)
- [Requirements Specification](requirements.md)

The next design milestone is the High-Level Architecture Diagram, where these assumptions will be considered alongside PayFlow's functional requirements, security needs, and data-consistency requirements.