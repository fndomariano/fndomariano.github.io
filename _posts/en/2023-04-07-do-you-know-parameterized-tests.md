---
layout:    post
title:    "Do you know Parameterized Tests?"
comments: true
lang: en
ref: do-you-know-parameterized-tests
excerpt:  "It is common behavior to refactor the production code to make it more readable during software development. But the test codes, do you have the same care?"
image: "/images/2023-04-07/organized.jpg"
feature_text: |
    ## Do you know Parameterized Tests?
tags:
    - Parameterized Tests
    - Java
    - Junit    
---

[Portuguese Version]({{site.baseurl}}/2023/04/07/voce-conhece-testes-parametrizados)

It is common behavior to refactor the production code to make it more readable during software development. But the test codes, do you have the same care? 

In this article, I wanna show you an easy way to write tests reducing lines and being more productive through the parameterized tests. 

The following examples are with Junit5. In order to correct working is necessary to install the [junit-jupiter-params](https://mvnrepository.com/artifact/org.junit.jupiter/junit-jupiter-params).

I created a simple code where the objective is to do a simple math operation with two numbers.

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
The example there is no mystery. It receives `x`, `y` and according to the operation, the result will be returned. If the operation is unknown the result will be zero. 

Testing this code without parameterized tests would generate five methods and a lot of lines like these ones:

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
In summary, one test by each operation. Now see how it works with parameterized tests.

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
Just put the `@ParameterizedTest` annotation, define the scenarios inside `@CsvSource` following the sequence of parameters on the test method and execute.

![Parameterized tests after execution on IntelliJ IDEA]({{site.baseurl}}/images/2023-04-07/parameterized_tests_executed.png)

![A person speaking easy peasy lemon squeezy]({{site.baseurl}}/images/2023-04-07/easy-peasy-lemon-squeezy.gif)

This text was simple as most I have produced. I think the goal was reached. But parameterized tests have quite options to explore. If you wanna know more about it, I do recommend the [Guide to JUnit 5 Parameterized Tests](https://www.baeldung.com/parameterized-tests-junit-5).