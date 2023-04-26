---
layout:    post
title:    "Você conhece testes parametrizados?"
comments: true
lang: br
ref: do-you-know-parameterized-tests
excerpt:  "É um comportamento comum refatorar o código principal da aplicação para deixar mais legível durante o desenvolvimento do software. Mas e códigos de testes você tem o mesmo cuidado?"
image: "/images/2023-04-07/organized.jpg"
feature_text: |
    ## Você conhece testes parametrizados?
tags:
    - Testes parametrizados
    - Java
    - Junit    
---

[Versão em Inglês]({{site.baseurl}}/2023/04/07/do-you-know-parameterized-tests)

É um comportamento comum refatorar o código principal da aplicação para deixar mais legível durante o desenvolvimento do software. Mas e códigos de testes você tem o mesmo cuidado?

Neste artigo, eu quero mostrar uma forma de escrever testes reduzindo o número de linhas e assim sendo mais produtivo fazendo o uso de testes parametrizados.

Os exemplos a seguir serão com _Junit5_. Para o funcionamento adequado é necessário a instalar a depêndencia [junit-jupiter-params](https://mvnrepository.com/artifact/org.junit.jupiter/junit-jupiter-params).

Criei um simples código onde o objetivo é apenas executar operações matemáticas com dois números.

```java
public class Calculator {

   private int x;
   private int y;

   private String operation;

   public Calculator (int x, int y, String operation) {
       this.x = x;
       this.y = y;
       this.operation = operation;
   }

   public int calculate() {

       switch (this.operation) {

           case "add":
               return x + y;

           case "subtract":
               return x - y;

           case "multiply":
               return x * y;

           case "divide":
               return x / y;

           default:
               return 0;
       }
   }
}
```
O exemplo acima não tem mistério. Recebe `x`, `y` e de acordo com a operação o resultado será retornado. Se a operação é de desconhecida, o resutado será zero.

Testar o código sem testes parametrizados geraria pelo menos cinco métodos e um monte de linhas como estas:

```java
public class CalculatorTest {

   @Test
   void mustTestAddition() {

       // given
       Calculator calculator = new Calculator(10, 2, "add");

       // when
       int result = calculator.calculate();

       // then
       Assertions.assertEquals(result, 12;
   }

   @Test
   void mustTestSubtraction() {

       // given
       Calculator calculator = new Calculator(10, 2, "subtract");

       // when
       int result = calculator.calculate();

       // then
       Assertions.assertEquals(result, 8);
   }

   @Test
   void mustTestMultiplication() {

       // given
       Calculator calculator = new Calculator(10, 2, "multiply");

       // when
       int result = calculator.calculate();

       // then
       Assertions.assertEquals(result, 20);
   }

   @Test
   void mustTestDivision() {

       // given
       Calculator calculator = new Calculator(10, 2, "divide");

       // when
       int result = calculator.calculate();

       // then
       Assertions.assertEquals(result, 5);
   }

   @Test
   void mustTestInvalidOperation() {

       // given
       Calculator calculator = new Calculator(10, 2, "any");

       // when
       int result = calculator.calculate();

       // then
       Assertions.assertEquals(result, 0);
   }
}
```
Resumindo seria um teste para cada operação. Agora veja como fica quando usamos testes parametrizados.

```java
public class CalculatorTest {
   
   @ParameterizedTest
   @CsvSource({
       "10,2,add,12",
       "10,2,subtract,8",
       "10,2,multiply,20",
       "10,2,divide,5",
       "10,2,any,0"
   })
   void mustTestCalculatorOperations(int x, int y, String operation, int expectedResult) {

       // given
       Calculator calculator = new Calculator(x, y, operation);

       // when
       int result = calculator.calculate();

       // then
       Assertions.assertEquals(result, expectedResult);
   }
}
```
É só adicionar a anotação `@ParameterizedTest`, definir os cenários dentro de `@CsvSource` seguindo a sequência de parâmetros que está declarada no método.

![Testes parametrizados após a executar na IDE IntelliJ]({{site.baseurl}}/images/2023-04-07/parameterized_tests_executed.png)

![Pessoa mostrando a parte interna das mãos como um gesto para mostrar que algo é fácil]({{site.baseurl}}/images/2023-04-07/easy.gif)

Apesar de ser um texto simples, eu acho que o objetivo foi cumprido. Mas os testes parametrizados tem várias formas de serem executados. Se você quiser se aprofundar mais, eu realmente recomendo o [Guia de testes automatizados no Junit5](https://www.baeldung.com/parameterized-tests-junit-5).