---
layout:    post
title:    "A simple way to work with Feature Flags"
comments: true
lang: en
ref: simple-way-to-work-with-feature-flags
excerpt:  "Delivering new things to the product is easier because the customers don’t know what is happening behind the walls. These normally don’t change functionalities are working. But what to do when there is a need to modify something working without brake de software?"
image: "/images/2023-03-17/interruptor.jpg"
feature_text: |
    ## A simple way to work with Feature Flags
tags:
    - Feature Flags
    - Feature Toogles
    - Flask
    - python
---

[Portuguese Version]({{site.baseurl}}/2023/03/17/uma-forma-simples-de-trabalhar-com-feature-flags)

In software development, it’s a common behavior to deliver pieces of features while they are still in construction. This practice calls [Continuous Delivery (CD)](https://en.wikipedia.org/wiki/Continuous_delivery) or [Continuous Integration (CI)](https://en.wikipedia.org/wiki/Continuous_integration). 

Delivering new things to the product is easier because the customers don’t know what is happening behind the walls. These normally don’t change functionalities are working. But what to do when there is a need to modify something working without brake de software? The answer to this issue is in the title of this article: Feature Flags!

[According to Martin Fowler](https://martinfowler.com/articles/feature-toggles.html):

> Feature Toggles (often also referred to as Feature Flags) are a powerful technique, allowing teams to modify system behavior without changing code.
 

Now we all know the Feature Flags concept, right? So, let’s see some code!

## Scenario

A company found out that most JSON responses of endpoints are without a pattern and opened many tasks to fix this. It’s important to know the front-end is another project, so the backend needs to do the modifications and can’t break the front-end project.

To simulate the scenario, I created a Flask project that owns an endpoint that returns information about products. 

The current response is like this:

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

and needs to be like this…

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
The first step in the implementation was to put a configuration in place to enable the Feature Flag.

```python
debug = os.getenv('DEBUG') == 'True'

app = Flask(__name__)

app.config['FEATURE_FLAG_PRODUCTS_JSON_REPONSE'] = debug
```
In summary, the code above enables the Feature Flag when the project is running in the development environment. To use it, simply add a condition and return the necessary information.

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
## Considerations

In software development there are many ways to add feature flags in products. For example, where working [with a Multitenancy application](https://en.wikipedia.org/wiki/Multitenancy), it is possible to deliver changes by a tenant. Additionally, more sophisticated methods, [like this one found on Github](https://github.com/rachelsanders/Flask-FeatureFlags) through a quick search on Google. Creating a secondary project to manage the flags with a database or using something like [Split](https://www.split.io/) might also be a good idea.

The objective of this article was to introduce you to the concept of Feature Flags, and provide a simple way to work with them. If you have any further questions about this concept, please send a message.
