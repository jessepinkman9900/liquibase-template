# Contribution Guidelines

## 1. Changelog Naming Scheme

- filename: `<timestamp>_filename.sql`
- timestamp: `yyyymmddhhmmss` in UTC

## 2. Creating Changesets

```sql
-- changeset <github_id>:1 labels:label1
-- precondition-sql-check expectedResult:<schema> SELECT schema_name FROM information_schema.schemata WHERE schema_name = '<schema>'
-- precondition-sql-check expectedResult:t SELECT EXISTS (SELECT FROM pg_tables WHERE  schemaname = '<schema>' AND tablename  = '<table>');
CREATE INDEX IF NOT EXISTS index_name
    ON <schema>.<table>
    USING btree (<column>);
-- rollback DROP INDEX IF EXISTS index_name
```

```sql
--changeset <github_id>:2 contextFilter:<filter1> labels:label1
ALTER TABLE <schema>.<table>
    ADD COLUMN timestamp TIMESTAMP(6) with time zone NOT NULL DEFAULT clock_timestamp();
-- rollback ALTER TABLE <schema>.<table> DROP COLUMN timestamp;
```

- changesets beings with `-- changeset <author>:<id> contextFilter:<filter1> labels:<label1>,<label2>`
    - each <id> must be unique
    - change sets are sorted by <id> in ascending order & executed in that order
    - use your github username as <author>
    - labels are used to group changesets & apply them selectively to required database
    - context filter is used provide describe environment context in which the changeset must be applied
    - labels & contextFilter can be used together. Read [this blog](https://www.liquibase.com/blog/contexts-vs-labels)
      for more details
- changesets must have `-- precondition-sql-check` to ensure that the changeset is executed only if the precondition is
  met
    - `expectedResult` is used to perform an equality check on the result of the query
- each changeset must have a `-- rollback` statement
    - rollback statement must undo the change made by the particular changeset. it should NOT make change to any other
      changeset
    - rollback statements MUST be idempotent
    - rollback statements are executed in descending order of changeset <id>
    - rollback statements are executed when liquibase rollback command is used

## 3. DOs & DONTs

## 3.1 Tables

| S.No | Type | Rule                                                                              | Rationale                                                                            |
|------|------|-----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| 1    | DO   | use `CREATE TABLE IF NOT EXISTS` to create tables                                 | all statements must be idempotent                                                    |
| 2    | DO   | add `precondition-sql-check` that ensure for all dependencies exist               | to build guarantees that if the statement has been executed it will work as expected |

## 3.2 Indexes

| S.No | Type | Rule                                              | Rationale                                                                                                      |
|------|------|---------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| 2    | DO   | use `CREATE INDEX IF NOT EXISTS` to create tables | all statements must be idempotent                                                                              |

## 3.3 Inserting Data

| S.No | Type | Rule                                          | Rationale                                                                   |
|------|------|-----------------------------------------------|-----------------------------------------------------------------------------|
| 1    | DO   | add `ON CONFLICT` resolution to SQL statement | to maintain idempotency & avoid statement execution failure during run-time |
