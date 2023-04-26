---
layout:    post
title:    "Uma forma simples de trabalhar com Feature Flags"
comments: true
lang: br
ref: uma-forma-simples-de-trabalhar-com-feature-flags
excerpt:  "Entregar coisas novas ao produto é mais fácil porque os clientes não sabem exatamente o que está acontecendo. Essas normalmente não alteram o que está funcionando. Mas o que fazer quando é necessário modificar algo que está rodando sem quebrar o software?"
image: "/images/2023-03-17/interruptor.jpg"
feature_text: |
    ## Uma forma simples de trabalhar com Feature Flags
tags:
    - Feature Flags
    - Feature Toogles
    - Flask
    - python
---

[Versão em Inglês]({{site.baseurl}}/2023/03/17/simple-way-to-work-with-feature-flags)

No desenvolvimento de software, é um comportamento comum entregar partes de funcionalidades enquanto ainda estão em desenvolvimento. Esta prática é chamada de [Entrega Contínua](https://pt.wikipedia.org/wiki/Entrega_cont%C3%ADnua) ou [Integração Contínua](https://pt.wikipedia.org/wiki/Integra%C3%A7%C3%A3o_cont%C3%ADnua).

Entregar coisas novas ao produto é mais fácil porque os clientes não sabem exatamente o que está acontecendo. Essas normalmente não alteram o que está funcionando. Mas o que fazer quando é necessário modificar algo que está rodando sem quebrar o software? A resposta para essa pergunta está no título deste texto: _Feature Flags!_

[De acordo com Martin Fowler](https://martinfowler.com/articles/feature-toggles.html):

> _Feature Toogles_ (também conhecida como _Feature Flags_) são uma poderosa técnica que permite times modificarem o comportamento do sistema sem alterar código. 

Agora nós entendemos o conceito de _Feature Flags_, certo? Vamos ver algum código então!

## Cenário

Uma empresa perecebeu que a maioria das respostas dos endpoints estão sem um padrão e abriu várias tarefas para corrigir. É importante saber que a parte de front-end é outro projeto, então o back-end precisa aplicar as modificações sem quebrar o front-end.

Para simular o cenário, criei um projeto usando Flask que possui um endpoint que retorna informações sobre produtos.

A resposta atual do endpoint está assim:

```json
[
  {
    "productActive": true,
    "productName": "SNES",
    "productPrice": 100
  },
  {
    "productActive": true,
    "productName": "Mega Drive",
    "productPrice": 150
  },
  {
    "productActive": true,
    "productName": "Atari 2600",
    "productPrice": 300
  }
]
```

e precisa ser assim: 

```json
{
  "data": [
    {
      "active": true,
      "name": "SNES",
      "price": 100.0
    },
    {
      "active": true,
      "name": "Mega Drive",
      "price": 150.0
    },
    {
      "active": true,
      "name": "Atari 2600",
      "price": 300.0
    }
  ]
}
```
O primeiro passo da implementação foi colocar uma configuração que permite habilitar a _Feature Flag_.

```python
debug = os.getenv('DEBUG') == 'True'

app = Flask(__name__)

app.config['FEATURE_FLAG_PRODUCTS_JSON_REPONSE'] = debug
```
Em resumo, o código acima diz que sempre que o projeto rodar em modo de desenvolvimento, a _Feature Flag_ vai estar ativa.

Para usá-la, não tem segredo. Apenas adicione uma condição, retorne o que é necessário e seja feliz =D

```python
@app.route("/products")
def products():
  
   response = {}
  
   if app.config['FEATURE_FLAG_PRODUCTS_JSON_REPONSE']:


       response['data'] = [
           {
               'name': 'SNES',
               'active': True,
               'price': 100.0       
           },
           {
               'name': 'Mega Drive',
               'active' :True,
               'price': 150.0       
           },
           {
               'name': 'Atari 2600',
               'active': True,
               'price': 300.0       
           }       
       ]
  
   else:
      
       response = [
           {
               'productName': 'SNES',
               'productActive': True,
               'productPrice': 100.0       
           },
           {
               'productName': 'Mega Drive',
               'productActive' :True,
               'productPrice': 150.0       
           },
           {
               'productName': 'Atari 2600',
               'productActive': True,
               'productPrice': 300.0       
           }       
       ]


   return jsonify(response)
```
## Considerações

No desenvolvimento de sofware existem muitas maneiras de adicionar _Feature Flags_ em produtos. Trabalhando em um [aplicação _multitenant_](https://en.wikipedia.org/wiki/Multitenancy) é possível enteregar as alterações por _tenant_. Também poderia ser uma forma mais refinada como [este repositório que eu encontrei no Github](https://github.com/rachelsanders/Flask-FeatureFlags) em uma busca rápida. Criar um projeto secundário para gerenciar as _flags_ através de um banco de dados ou usar algo como [Split](https://www.split.io/) talvez não seja uma má ideia.

O objetivo deste artigo foi introduzir para você - se não conhecia - as _Feature Flags_. Isso foi uma maneira simples de trabalhar com elas e se você deseja falar mais sobre este conceito basta me enviar uma mensagem.

