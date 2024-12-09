### Normalization

The process of refining a database design to ensure that each independent piece of information is in only one place (
except for foreign keys) is known as normalization.

## Terms and Definitions

Entity: Something of interest to the database user community. Examples include customers, parts, geographic locations,
etc.

Column: An individual piece of data stored in a table.

Row: A set of columns that together completely describe an entity or some action on an entity. Also called a record.

Table: A set of rows, held either in memory (nonpersistent) or on permanent storage (persistent).

Result set: Another name for a nonpersistent table, generally the result of an SQL query.

Primary key: One or more columns that can be used as a unique identifier for each row in a table.

Foreign key: One or more columns that can be used together to identify a single row in another table.

### Data Dictionary

All database elements created via SQL schema statements are stored in a special set of tables called the data
dictionary. This “data about the database” is known collectively as metadata

### Non-Procedural Language

SQL is a non-procedural language.
