---
layout:    post
title:    "A história do desenvolvedor que não costumava usar testes unitários"
comments: true
lang: br
ref: a-historia-do-desenvolvedor-que-nao-custumava-usar-testes-automatizados
excerpt: "Em alguns trabalhos, eu nunca tive a oportunidade de implementar testes automatizados. Cada funcionalidade nova ou bug corrigido foi programado sem. A minha experiência com testes automatizados foi breve até ano passado. É por causa desse motivo, que eu decidi escrever este artigo. Eu quero compartilhar minha pouca experiência neste assunto."
image: "/images/2021-01-03/automated-tests.jpg"
feature_text: |
    ## A história do desenvolvedor que não costumava usar testes unitários
tags:
    - Testes automatizados
---

[Versão em Inglês]({{site.baseurl}}/2021/01/03/the-developer-story-did-not-use-to-implement-automated-tests)

Em alguns trabalhos, eu nunca tive a oportunidade de implementar testes automatizados. Cada funcionalidade nova ou bug corrigido foi programado sem. A minha experiência com testes automatizados foi breve até ano passado. É por causa desse motivo, que eu decidi escrever este artigo. Eu quero compartilhar minha pequena experiência neste assunto.

Eu sempre ouvi falar que testes automatizados eram sobre qualidade de software, mas nunca ouvi alguém falar que também eram sobre segurança do desenvolvedor. Se você não entendeu onde eu quero chegar, você pode imaginar um desenvolvedor júnior que começou a trabalhar em uma empresa, ele recebeu um tarefa e ela parecia ser fácil de fazer. Ele codificou, testou manualmente e enviou para produção. Algumas horas depois os clientes começaram a ligar para empresa com reclamações. Depois de investigar, o time descobriu que o código do desenvolvedor júnior quebrou outras regras de negócio. Mas como ele poderia saber que isso iria acontecer? Ele é novo na empresa e não conhece todas as regras. Agora imagine um cenário, onde todas as regras estão cobertas por testes, antes deste desenvolvedor enviar, ele constrói os testes para a tarefa dele e quando ele roda todos os testes é possível enxergar que sua implementação está quebrando outras áreas do produto. Isso é segurança do desenvolvedor. Os testes automatizados fazem o desenvolvimento de software mais leve, mais confortável e remove um pouquinho do medo sobre tarefas difíceis.

No exemplo anterior, falei sobre um desenvolvedor júnior e talvez ele não saiba como fazer uso de testes automatizados. Mas ele precisa aprender como fazer. Eu estudei testes assistindos bons cursos que explicam conceitos como *mocks*, *factories* e como separar meus testes em `given-when-then`. As ferramentas são importantes também, porém os conceitos são muito mais, quando você os entende, é possível usar em outras linguagens de programação.

Vamos tentar um outro exerício. O desenvolvedor recebe uma tarefa onde ele precisa codificar a seguinte.

> Quando todos os movimentos de um processo estiverem com o status 'finalizado', um evento será disparado para informar outros serviços sobre isto e o status do processo também ficará finalizado. Se qualquer movimento do processo estiver com status diferente de 'finalizado' então nada precisará ser feito.

Olhando para a descrição da tarefa, nós podemos fazer ao menos três testes.

- Um teste com um processo que contém vários movimentos finalizados.
- Um teste com um processo que contém apenas um movimento finalizado.
- Um teste com um processo que contém movimentos com diferentes status.

Quando o desenvolvedor escreveu os testes, ele descobriu que quando um processo tem apenas um movimento, o status do processo não pode ser alterado, porque em passos anteriores existe um problema que não deixa realizar esta ação. Os testes automatizados nos ajudam a pensar com maturidade, ele nos incentiva a cobrir muitas possibilidades e assim nós podemos evitar situações ruins. Claro, este mesmo problema poderia ser encontrado com testes manuais, mas é mais moroso, porque sempre será necessário preparar os ambientes e os testes automatizados sempre terão os cenários contruídos prontos para serem quebrados. Haha! :D

Os exemplos neste texto são minhas experiências, tudo aconteceu de verdade. Hoje eu estou codificando usando testes automatizados e não me vejo mais sem usá-los. Os testes automatizados me ajudaram a crescer como desenvolvedor, sendo assim, eu recomendo a vocês estudarem e se possível, coloque em seu trabalho.

Esse foi meu primeiro conteúdo de 2021, eu espero que tenham gostado. Deixe suas dúvidas nos comentários, eu apreciaria falar com vocês sobre este tema.