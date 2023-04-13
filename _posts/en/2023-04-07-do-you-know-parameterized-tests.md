---
layout:    post
title:    "Do you know Parameterized Tests?"
comments: true
lang: en
ref: do-you-know-parameterized-tests
excerpt:  "Refactoring production code is common behavior to make it more readable during software development. What about test codes, do you have the same care?"
image: "/images/2023-04-07/organized.jpg"
feature_text: |
    ## Do you know Parameterized Tests?
tags:
    - Parameterized Tests
    - Java
    - Junit    
---

[Portuguese Version]({{site.baseurl}}/2023/04/07/voce-conhece-testes-parametrizados)

Refactoring production code is common behavior to make it more readable during software development. What about test codes, do you have the same care?

In this article, I wanna show you an easy way to reduce lines and be more produtive when writing tests.

The following examples use Junit5. In order for tests to work properly, it is necessary to install [junit-jupiter-params](https://mvnrepository.com/artifact/org.junit.jupiter/junit-jupiter-params).

I've created a simple code that performs a basic math operation.

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
The example has no secret. It receives `x`, `y` and, according to the operation, the result will be returned. If the operation is unknown the result will be zero. 

Testing this code without parameterized tests would generate five methods at least and a lot of lines like these ones:

```java
public class CalculatorTest {

   @Test
   void mustTestAddition() {

       // given
       Calculator calculator = new Calculator(10, 2, "add");

       // when
       int result = calculator.calculate();

       // then
       Assertions.assertEquals(result, 12);
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
In summary, one test for each operation. Now, see how it works with parameterized tests.

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
Just add the `@ParameterizedTest` annotation, define the scenarios inside `@CsvSource` following the sequence of parameters on the test method and execute.

![Parameterized tests after execution on IntelliJ IDEA]({{site.baseurl}}/images/2023-04-07/parameterized_tests_executed.png)

![A person speaking easy peasy lemon squeezy]({{site.baseurl}}/images/2023-04-07/easy-peasy-lemon-squeezy.gif)


Although this text is simple, I think the goal was achieved. However, parameterized tests have quite options to explore. If you wanna know more about it, I do recommend the [Guide to JUnit 5 Parameterized Tests](https://www.baeldung.com/parameterized-tests-junit-5).