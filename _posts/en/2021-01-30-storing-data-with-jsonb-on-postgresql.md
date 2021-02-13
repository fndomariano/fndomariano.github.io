---
layout:    post
title: "Storing data with JSONB on PostgreSQL"
comments: true
lang: en
ref: storing-data-with-jsonb-on-postgresql
excerpt:  "Recently I’ve been working with a kind of data called JSONB and I’ve decided to write about it. Basically this kind of data is a JSON, but there are differences according the PostgresSQL’ documentation."
image: "/images/2021-01-30/"
feature_text: |
    ## Storing data with JSONB on PostgreSQL
tags:
    - PostgreSQL
    - jsonb
    - database
---

[Portuguese Version]({{site.baseurl}}/2021/01/30/armazenando-dados-com-jsonb-no-postgresql)

Recently I've been working with a kind of data called `jsonb` and I've decided to write about it. This kind of data is a `json`, but there are differences [according to the PostgreSQL documentation](https://www.postgresql.org/docs/9.4/datatype-json.html){:target="_blank"}.

>The json data type stores an exact copy of the input text, which processing functions must reparse on each execution; while jsonb data is stored in a decomposed binary format that makes it slightly slower to input due to added conversion overhead, but significantly faster to process, since no reparsing is needed. jsonb also supports indexing, which can be a significant advantage.

## Hands-on

Having this in mind, I'm going to show some examples.

### Creating a table

```sql
create table products (
	id varchar(36) not null,
	data jsonb not null,
	constraint product_pkey primary key (id)
);
```

### Inserting

```sql
insert into products values('d987878a-630a-11eb-ae93-0242ac130002', '{"name": "SNES", "price": 400.0, "measure": "UNIT"}');
insert into products values('2223ba5c-630d-11eb-ae93-0242ac130002', '{"name":"Beer","price":8.50,"measure":"UNIT","features":{"size":"600ML","expiration_date":"2021-04-01","manufacture_date":"2020-07-16"}}');
insert into products values('cd5a77d0-630d-11eb-ae93-0242ac130002', '{"name":"Cookie","price":2.0,"measure":"UNIT","features":{"expiration_date":"2021-03-14","manufacture_date":"2020-04-13"},"barCodes":["78900050501","78900050502","78900050503","78900050504"]}');
```

### Selecting data

**a)** Getting registers that having `features`.

```sql
select id, data->>'name' as name 
from products 
where data->'features' is not null;
```
_Result_:

```text
| id                                   | name    |
| -----------------------------------  | ------- |
| 2223ba5c-630d-11eb-ae93-0242ac130002 | Beer    | 
| cd5a77d0-630d-11eb-ae93-0242ac130002 | Cookie  |
```

**b)** Getting values by index.

```sql
select id, data->>'name' as name, 
       data->'barCodes'->>0 as first_bar_code,
       data->'barCodes'->>-1 as last_bar_code
from products
```

_Result_: 

```text
| id                                   | name   | first_bar_code  | last_bar_code |
| ------------------------------------ | ------ | --------------- | ------------- |
| d987878a-630a-11eb-ae93-0242ac130002 | SNES   | NULL            | NULL          |
| 2223ba5c-630d-11eb-ae93-0242ac130002 | Beer   | NULL            | NULL          |
| cd5a77d0-630d-11eb-ae93-0242ac130002 | Cookie | 78900050501     | 78900050504   |
```

**c)** Grouping with the `jsonb_agg` function.

```sql
select jsonb_agg(data->>'name') as names
from products 
group by data->>'measure'
```

_Result_:

```text
| names                      |
| -------------------------- | 
| ["SNES", "Beer", "Cookie"] |
```


### Updating rows

The following examples will be with `jsonb_set` function. This one has four arguments. 

* `target`: The jsonb that will be changed.
* `path`: The attribute that needs to be found on the `target`.
* `new_value`: The value that will be put on `target`.
* `create_missing`: If true and the argument `new_value` doesn't exist on `target`, then will be created. By default is `true`.

**a)** Creating a new attribute.

```sql
update products 
set data = jsonb_set(data, '{features}', '{"width": "203.2mm", "height": "68mm", "depth":"254mm"}', true)
where id = 'd987878a-630a-11eb-ae93-0242ac130002';
```

_Result_:

```json
{
  "name": "SNES",
  "price": 400.0,
  "measure": "UNIT",
  "features": {
    "depth": "254mm",
    "width": "203.2mm",
    "height": "68mm"
  }
}
```

**b)** Removing an attribute.

```sql
update products set data = data - 'price'
where id = 'cd5a77d0-630d-11eb-ae93-0242ac130002';

select id,
       data->>'name' as name,
       data->'price' as price 
from products 
where id = 'cd5a77d0-630d-11eb-ae93-0242ac130002';
```

_Result_:

```text
| id                                   | name   | price |
| ------------------------------------ | ------ | ----- |
| cd5a77d0-630d-11eb-ae93-0242ac130002 | Cookie | NULL  |
```

**c)** Changing values.

```sql
update products 
set data = jsonb_set(data, '{price}', to_jsonb(500.0), false)
where id = 'd987878a-630a-11eb-ae93-0242ac130002';

select id,
       data->>'name' as name,
       data->'price' as price 
from products 
where id = 'd987878a-630a-11eb-ae93-0242ac130002';
```
_Result_:

```text
| id                                   | name  | price |
| ------------------------------------ | ----- | ----- |
| d987878a-630a-11eb-ae93-0242ac130002 | SNES  | 500.0 |
```

In the last example, was necessary to use the `to_jsonb` function to cast the value.


## Considerations

It still a lot of other issues to explore as indexes and functions, but my goal was to make an introduction about this kind of data. This article was my first writing about databases and I hope you've liked it. If you have any doubt, let me know in the comments.
