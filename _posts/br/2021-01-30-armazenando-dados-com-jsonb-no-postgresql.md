---
layout:    post
title: "Armazenando dados com JSONB no PostgreSQL"
comments: true
lang: br
ref: armazenando-dados-com-jsonb-no-postgresql
excerpt:  "Recentemente estive trabalhando com um tipo de dados chamado JSONB e decidi escrever sobre. Basicamente este tipo de dado é um JSON, mas existem diferenças de acordo com a documentação do PostgreSQL."
image: "/images/2021-01-30/postgresql-logo.jpg"
feature_text: |
    ## Armazenando dados com JSONB no PostgreSQL
tags:
    - PostgreSQL
    - jsonb
    - banco de dados
---

[Versão em Inglês]({{site.baseurl}}/2021/01/30/storing-data-with-jsonb-on-postgresql)

Recentemente estive trabalhando com um tipo de dados chamado `jsonb` e decidi escrever sobre. Basicamente este tipo de dado é um `json`, mas existem diferenças [de acordo com a documentação do PostgreSQL](https://www.postgresql.org/docs/9.4/datatype-json.html){:target="_blank"}.

>O tipo json armazena uma cópia exata do texto de entrada, cuja as funções devem ser repartidas em cada execução; enquanto o tipo de dado jsonb é armazenado em um formato binário decomposto que torna a entrada ligeiramente mais lenta devido a sobrecarga de conversão adicionada, mas significativamente mais rápida de processar, desde que não é necessário reparar. O jsonb também suporta indexação, o que pode ser uma vantagem significativa.

## Mãos na massa

Tendo isso em mente, vou mostrar alguns exemplos and introduzir para você.

### Criando uma tabela

```sql
create table products (
	id varchar(36) not null,
	data jsonb not null,
	constraint product_pkey primary key (id)
);
```

### Inserindo

```sql
insert into products values('d987878a-630a-11eb-ae93-0242ac130002', '{"name": "SNES", "price": 400.0, "measure": "UNIT"}');
insert into products values('2223ba5c-630d-11eb-ae93-0242ac130002', '{"name":"Beer","price":8.50,"measure":"UNIT","features":{"size":"600ML","expiration_date":"2021-04-01","manufacture_date":"2020-07-16"}}');
insert into products values('cd5a77d0-630d-11eb-ae93-0242ac130002', '{"name":"Cookie","price":2.0,"measure":"UNIT","features":{"expiration_date":"2021-03-14","manufacture_date":"2020-04-13"},"barCodes":["78900050501","78900050502","78900050503","78900050504"]}');
```

### Selecionando dados

**a)** Obtendo registros que tem `features`.

```sql
select id, data->>'name' as name 
from products 
where data->'features' is not null;
```
_Resultado_:

```text
| id                                   | name    |
| -----------------------------------  | ------- |
| 2223ba5c-630d-11eb-ae93-0242ac130002 | Beer    | 
| cd5a77d0-630d-11eb-ae93-0242ac130002 | Cookie  |
```

**b)** Obtendo valores por posição.

```sql
select id, data->>'name' as name, 
       data->'barCodes'->>0 as first_bar_code,
       data->'barCodes'->>-1 as last_bar_code
from products
```

_Resultado_: 

```text
| id                                   | name   | first_bar_code  | last_bar_code |
| ------------------------------------ | ------ | --------------- | ------------- |
| d987878a-630a-11eb-ae93-0242ac130002 | SNES   | NULL            | NULL          |
| 2223ba5c-630d-11eb-ae93-0242ac130002 | Beer   | NULL            | NULL          |
| cd5a77d0-630d-11eb-ae93-0242ac130002 | Cookie | 78900050501     | 78900050504   |
```

**c)** Agrupando dados com a função `jsonb_agg`.

```sql
select jsonb_agg(data->>'name') as names
from products 
group by data->>'measure'
```

_Resultado_:

```text
| names                      |
| -------------------------- | 
| ["SNES", "Beer", "Cookie"] |
```

### Atualizando registros

Para os exemplos seguintes, vai ser usada a função `jsonb_set`. Ela possui quatro parâmetros.

* `target`: O `jsonb` que vai ser modificado.
* `path`: O atributo que precisa ser encontrado no `target`.
* `new_value`: O valor que vai ser colocado no `target`.
* `create_missing`: Se é _true_ e o parâmetro `new_value` não está no `target`, então será criado. O valor padrão é _true_ .

**a)** Criando um novo atributo.

```sql
update products 
set data = jsonb_set(data, '{features}', '{"width": "203.2mm", "height": "68mm", "depth":"254mm"}', true)
where id = 'd987878a-630a-11eb-ae93-0242ac130002';
```

_Resultado_:

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

**b)** Removendo um atributo.

```sql
update products set data = data - 'price'
where id = 'cd5a77d0-630d-11eb-ae93-0242ac130002';

select id,
       data->>'name' as name,
       data->'price' as price 
from products 
where id = 'cd5a77d0-630d-11eb-ae93-0242ac130002';
```

_Resultado_:

```text
| id                                   | name   | price |
| ------------------------------------ | ------ | ----- |
| cd5a77d0-630d-11eb-ae93-0242ac130002 | Cookie | NULL  |
```

**c)** Alterando valores.

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
_Resultado_:

```text
| id                                   | name  | price |
| ------------------------------------ | ----- |------ |
| d987878a-630a-11eb-ae93-0242ac130002 | SNES  | 500.0 |
```

No último exemplo, foi necessário usar a função `to_jsonb` para converter o valor.

## Considerações

Ainda existem outras questão à explorar como indexes e funções, mas meu objetivo era fazer apenas uma introdução sobre este tipo de dados. Este foi meu primeiro texto sobre banco de dados e espero que tenham gostado. Qualquer dúvida deixe um comentário.