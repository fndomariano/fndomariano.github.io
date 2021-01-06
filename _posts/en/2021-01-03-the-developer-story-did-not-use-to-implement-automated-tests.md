---
layout:    post
title:    "The developer story who did not use to implement automated tests"
comments: true
lang: en
ref: the-developer-story-did-not-use-to-implement-automated-tests
excerpt:  "In some jobs, I never had the opportunity to implement automated tests. Each new feature or fixed bug was programmed without them. My experience with automated tests was brief until last year. That's why I've decided to write this article. I intend to share my short experience with this subject."
image: "/images/2021-01-03/automated-tests.jpg"
feature_text: |
    ## The developer story who did not use to implement automated tests
tags:
    - Automated tests
---

[Portuguese Version]({{site.baseurl}}/2021/01/03/a-historia-do-desenvolvedor-que-nao-custumava-usar-testes-automatizados)

In some jobs, I never had the opportunity to implement automated tests. Each new feature or fixed bug was programmed without them. My experience with automated tests was brief until last year. That's why I've decided to write this article. I intend to share my short experience with this subject.

Always I heard that automated tests were about the quality of software, but I never heard someone speaking about developer security. If you did not understand where I want to arrive, you can think of a junior developer who started in a company, he got a task and it looked easy to do. He made the code, tested it manually, and sent it to production. Some hours after, the customers contacted the company with claims. After investigating, the team figured out that the junior developer code broke other business rules. But, how could he know this would happen? He is new in the company and doesn't know all the business rules. Now imagine a scenario where the rules are covered with automated tests and before he sends, he builds automated tests for his task and when he runs all, he could see that his implementation broke other product areas. This is developer security. The automated tests make the software development lighter, more comfortable, and remove a little bit of the fear about hard tasks.

In the previous example, I spoke about a junior developer and maybe he doesn't know how to use automated tests. But he needs to learn how to do that. I studied tests watching good courses that explained concepts as mocks, factories, and how to separate my tests in `given-when-then`. The tools are important too, but the concepts are much more, because when you understand them, you can use them in other programming languages.

Let's try another exercise. The developer receives an issue where he needs to code the following.

> When all process' movements got status 'finished', an event will be dispatched to inform another service about this and the process status also will be finished. If any process' movement has a different status, nothing needs to be done.

Looking for the task description we can build three tests at least.

- A test with several finished process’ movements.
- A test with one process' movement finished.
- A test with different process' movements status.

When the developer wrote the tests, he discovered that when a process has only one movement, the process status cannot be changed because the before steps there is a problem that doesn't allow this action. The automated tests help us to think with maturity, cause it encourages us to cover many possibilities and like this, we can avoid bad situations. Of course, this problem could be figured out with manual tests, but it is slower because always we'll need to prepare the environments and the automated tests already have the scenarios ready to broke. Haha! :D

The examples in this article are my experiences, everything really happened. Today I'm coding using automated tests and I don't see myself don't use it anymore. The automated tests have helped me grow up as a developer, so I really recommend you to study this and if you can, put in work on your jobs.

It was my first 2021 content, I hope you've liked it. Let your doubts in the comments, I would appreciate talking with you about this theme.