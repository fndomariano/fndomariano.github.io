---
layout:    post
title:    "The developer's story who didn't used to implement automated tests"
comments: true
lang: en
ref: the-developer-story-didnt-used-to-implement-automated-tests
excerpt:  "In some jobs, I never had a opportunity to implement automated tests. Each new feature or fixed bug was programmmed without them. My experience with automated tests were brief until last year. That's why I've decided to write this article. I intent to share my short experience in this subject."
image: "/images/2021-01-03/automated-tests.jpg"
feature_text: |
    ## The developer's story who didn't used to implement automated tests
tags:
    - Automated tests
---

[Portuguese Version]({{site.baseurl}}/2021/01/03/a-historia-do-desenvolvedor-que-nao-custumava-usar-testes-automatizados)

In some jobs, I never had a opportunity to implement automated tests. Each new feature or fixed bug was programmmed without them. My experience with automated tests were brief until last year. That's why I've decided to write this article. I intent to share my short experience in this subject.

Always I heard that automated tests were about quality of software, but I never heard someone speaking about developer security. If you did not understand where I want to arrive, you can think in a junior developer who started in a company, he got a chore and it looked easy to do. He made the code, he tested manually and sent to production. Some hours after, the customers contacted the company with claims. After investigate, the team figured out that the junior developer code broke other business rules. But, how could he know this would happen? He is new on the company and doesn't know all the business rules. Now imagine a scenario where the rules are covered with automated tests and before he sends, he builds automated tests for his task and when he runs all, he could see that his implementation broke other product areas. This is developer security. The automated tests make the software development more light, more confortable and remove a little bit the fear about hard tasks.

In the previus example, I spoke about a junior developer and maybe he doesn't know how to use automated tests. But he needs to learn how to do that. I studied tests watching good courses that explained concepts as mocks, factories and how to separate my tests in `given-when-then`. The tools are important too, but the concepts are much more, because when you understand them, you can use in other programming languages.

Let's try another exercise. The developer receive a issue where he needs to code the following.

> When all process' moviments got status 'finished', a event will be dispached to inform other service about this and the process status also will be finished. If any process' moviment has a different status, nothing needs to be done.

Looking for the task description we can build three tests at least.

- A test with a serveral finished process' moviments.
- A test with one process' moviment finished.
- A test with different process' moviments status

When the developer wrote the tests, he discovered when a process has only one moviment, the process status cannot be changed because the before steps there is a problem that don't allow this action. The automated tests help us to think with maturity, cause it encourages us to cover many possibilites and like this we can avoid bad situations. Of course, this problem could be figured out with manual tests, but it is more slow, because always we'll need need to prepare the enviroments and the automated tests already have the scenarios ready to broke. Haha! :D

The examples in this article are my experiences, everything really happened. Today I'm coding using automated tests and I don't see myself don't using it anymore. The automated tests have helped me grow up as a developer, so I really recommend you to study this and if you can, put in work on your jobs.

It was my first 2021 content, I hope you've liked. Let your doubts in comments, I would apreciate to talk with you about this theme.