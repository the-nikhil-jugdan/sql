# Creating and Populating a Database

## MySQL Data Types

### Character Data

```mysql
char
    (20); /* fixed-length */
varchar
    (20); /* variable-length */
```

The maximum length for char columns is currently 255 bytes, whereas varchar columns can be up to 65,535 bytes

If you need to store longer strings (such as emails, XML documents, etc.), then you will want to use one of the text
types (mediumtext and longtext)

In general, you should use the char type when all strings to be stored in the column are of the same length, such as
state abbreviations, and the varchar type when strings to be stored in the column are of varying lengths

#### Character Sets

For languages that use the Latin alphabet, such as English, there is a sufficiently small number of characters such that
only a single byte is needed to store each character. Other languages, such as Japanese and Korean, contain large
numbers of characters, thus requiring multiple bytes of storage for each character. Such character sets are therefore
called multibyte character sets.

To see the supported character sets in the server.

```mysql
show character set;
```

If the value in the fourth column, maxlen, is greater than 1, then the character set is a multibyte character set.

To choose a character set other than the default when defining a column, simply name one of the supported character sets
after the type definition, as in:

```mysql
varchar
    (20)
    character
set latin1;
``` 

For entire DB

```mysql
create database european_sales character set latin1;
```

### Text Data

If you need to store data that might exceed the 64 KB limit for varchar columns, you will need to use one of the text
types.

Text type: Maximum number of bytes

Tinytext: 255

Text: 65,535

Mediumtext: 16,777,215

Longtext: 4,294,967,295

When choosing to use one of the text types, you should be aware of the following:

- If the data being loaded into a text column exceeds the maximum size for that type, the data will be truncated.

- Trailing spaces will not be removed when data is loaded into the column.

- When using text columns for sorting or grouping, only the first 1,024 bytes are used, although this limit may be
  increased if necessary.

- The different text types are unique to MySQL. SQL Server has a single text type for large character data, whereas DB2
  and Oracle use a data type called clob, for Character Large Object.

- Now that MySQL allows up to 65,535 bytes for varchar columns (it was limited to 255 bytes in version 4), there isn’t
  any
  particular need to use the tinytext or text type.

### Numeric Data

#### Integers

Type, Signed range, Unsigned range

Tinyint, −128 to 127, 0 to 255

Smallint, −32,768 to 32,767, 0 to 65,535

Mediumint, −8,388,608 to 8,388,607, 0 to 16,777,215

Int, −2,147,483,648 to 2,147,483,647, 0 to 4,294,967,295

Bigint, −2^63 to 2^63 - 1, 0 to 2^64 - 1

When you create a column using one of the integer types, MySQL will allocate an appropriate amount of space to store the
data, which ranges from one byte for a tinyint to eight bytes for a bigint. Therefore, you should try to choose a type
that will be large enough to hold the biggest number you can envision being stored in the column without needlessly
wasting storage space.

#### Floating Point Data

For floating-point numbers (such as 3.1415927), you may choose from the numeric types Float and Double

Float( p , s ) -> −3.402823466E+38 to −1.175494351E-38 and 1.175494351E-38 to 3.402823466E+38

Double( p , s ) -> −1.7976931348623157E+308 to −2.2250738585072014E-308 and 2.2250738585072014E-308 to
1.7976931348623157E+308

When using a floating-point type, you can specify a precision (the total number of allowable digits both to the left and
to the right of the decimal point) and a scale (the number of allowable digits to the right of the decimal point), but
they are not required

If you specify a precision and scale for your floating-point column, remember that the data stored in the column will be
rounded if the number of digits exceeds the scale and/or precision of the column. For example, a column defined as
float(4,2) will store a total of four digits, two to the left of the decimal and two to the right of the decimal.
Therefore, such a column would handle the numbers 27.44 and 8.19 just fine, but the number 17.8675 would be rounded to
17.87, and attempting to store the number 178.375 in your float(4,2) column would generate an error

### Temporal Data

Temporal Data: Information about dates and/or times.

MYSQL Temporal Types

Type
Default format
Allowable values

Date
YYYY-MM-DD
1000-01-01 to 9999-12-31

Datetime
YYYY-MM-DD HH:MI:SS
1000-01-01 00:00:00.000000
to 9999-12-31 23:59:59.999999

Timestamp
YYYY-MM-DD HH:MI:SS
1970-01-01 00:00:00.000000
to 2038-01-18 22:14:07.999999

Year
YYYY
1901 to 2155

Time
HHH:MI:SS
−838:59:59.000000
to 838:59:59.000000

While database servers store temporal data in various ways, the purpose of a format string to show how the data will be
represented when retrieved, along with how a date string should be constructed when inserting or updating a temporal
column.

Date Format Components

Component Definition Range

YYYY
Year, including century
1000 to 9999

MM
Month
01 (January) to 12 (December)

DD
Day
01 to 31

HH
Hour
00 to 23

HHH
Hours (elapsed)
−838 to 838

MI
Minute
00 to 59

SS
Second
00 to 59


