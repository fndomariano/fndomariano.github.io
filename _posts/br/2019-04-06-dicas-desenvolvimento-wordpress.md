---
layout:    post
title:    "Dicas para desenvolvimento com Wordpress"
comments: true
lang: br
ref: wordpress-development-tips
excerpt:  "Este texto é um pouco diferente dos anteriores onde falei assuntos que falavam sobre dados. Aqui pretendo ilustrar algumas dicas no desenvolvimento de projetos em Wordpress."
image: "/images/2019-04-06/wordpress.jpg"
feature_text: |
    ## Dicas para desenvolvimento com Wordpress
tags:
    - wordpress
    - php
---

[Versão em Inglês]({{site.baseurl}}/2019/04/06/wordpress-development-tips)

Este texto é um pouco diferente dos anteriores onde falei assuntos que falavam sobre dados. Aqui pretendo ilustrar algumas dicas no desenvolvimento de projetos em Wordpress.

### Transaction

Muitas vezes nós precisamos importar dados que serão utilizados para exibir em algum projeto. O processo de importação é passivel de erros quando está em atividade, logo precisamos garantir que em casos com problemas as informações não sejam importadas incompletas. Sendo assim, para esses casos o mais correto é utilizar as ```transactions```. Claro, este é apenas um exemplo, as ```transactions``` podem ser usadas para outras finalidades que não tenham relação com alguma importação.

```php 
function addPostExample() {

    // Variável global do Wordpress
    global $wpdb; 
    
    // Iniciamos a transaction
    $wpdb->query('START TRANSACTION');
    
    // Definimos algumas informações para o post
    $postData = [
        'post_title'     => 'Title example',  
        'post_type'      => 'post-type-example',
        'post_status'    => 'publish',
        'comment_status' => 'closed',
        'ping_status'    => 'closed'
    ];
    
    // Inserimos o post
    $postExample = wp_insert_post($postData, true);

    // Possui erro?
    if (is_wp_error($postExample)) {
        
        // Então fazemos o rollback
        $wpdb->query('ROLLBACK');
        return;
    } 
    
    // Não tem erro? Então é salvo o registro
    $wpdb->query('COMMIT');
        
    // Retorna o id do post
    return $postExample;
}
```

### Truncate text

Uma situação que acontece muitas vezes é quando precisarmos exibir somente parte de um conteúdo, como por exemplo a prévia de um texto para chamar a atenção do leitor. 

Trabalhei em alguns projetos onde desenvolvedores fizeram uma função para cortar uma certa quantidade de palavras, mas não havia necessidade, pois o Wordpress já possui uma função para esse tipo de tarefa.

```php
$text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In suscipit convallis neque non suscipit. Nunc interdum ultrices ultrices. Interdum et malesuada fames ac ante ipsum primis in faucibus. Donec id justo tincidunt, porta mi vitae, sodales nibh. Nulla quis velit at erat maximus porta. Mauris sit amet consequat ligula. Vivamus congue pretium fermentum. Duis non lorem sodales, aliquam sapien quis, sodales elit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vestibulum ut ex ultricies, iaculis velit a, suscipit sem. Maecenas pharetra est vitae ipsum posuere, ac elementum lorem condimentum. Maecenas congue ac magna euismod euismod.';

echo wp_trim_words($text, $numWords = 10, '...');
```

No código acima é utilizada a função ```wp_trim_words``` que possui três parâmetros. O primeiro é o texto (Lorem Ipsum) que será cortado, o segundo significa quantas palavras serão mostradas e o último é o que vai ser concatenado com texto após o corte. Para exemplificar utilizei um trecho de um ```Lorem Ipsum```. O resultado ficará assim:

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In suscipit...
```

### Usar o _atributo posts_

Em projetos que usam Wordpress é muito comum encontrarmos consultas utilizando ```WP_Query``` e em seguida percorrer os resultados utilizando um ```while``` conforme no exemplo abaixo:

```php
<?php 

// Montamos a query
$query = new WP_Query([
    'post_type'      => 'post-type-example',
    'post_status'    => 'publish',
    'posts_per_page' => 5
]);

?>

// Verifica se possui posts e depois integra o resultado com a estrutura HTML
<?php if ($query->have_posts()): ?>
    <ul>
        <?php while ($query->have_posts()): $query->the_post(); ?>
            <li><?php echo get_the_title() ?></li>
        <?php endwhile ?>
    </ul>
    
    // Reseta a query para não conflitar com outras consultas
    <?php wp_reset_postdata() ?>
<?php endif ?>
```

Agora um exemplo usando o _atributo posts_. O objeto ```WP_Query``` tem o _atributo posts_  que é um ```array``` e podemos usar com  ```foreach``` conforme o ```PHP``` sugere.

```php
<?php 

// Montamos a query
$query = new WP_Query([
    'post_type'      => 'post-type-example',
    'post_status'    => 'publish',
    'posts_per_page' => 5
]);

?>

// Verifica se possui posts e depois integra o resultado com a estrutura HTML
<?php if ($query->posts): ?>
    <ul>
        <?php foreach ($query->posts as $item): ?>
            <li><?php echo $item->post_title ?></li>
        <?php endforeach ?>
    </ul>	
<?php endif ?>
```
Do meu ponto de vista, com esta abordagem fica mais simples de efetuar uma leitura em código.

### Função _wp_list_pluck_ 

Outra situação que encontrei em muitos projetos foi de que a lógica usada precisava verificar se existiam IDs de uma query em um ```array```. Até aí tudo bem, mas para obter os IDs da consulta, o desenvolvedor criou uma função separada que retornava um outro ```array``` contendo somente os IDs. Como no exemplo abaixo:

```php
// Função para retornar IDs
function get_ids($query) {

    // Se não tem posts
    if (!$query->posts) {
        return false;
    }

    // array vazios para inserir os ids
    $ids = [];

    // percorre a consulta usando o atributo posts =DDD
    foreach ($query->posts as $item) {
        
        // Insere os IDs no array
        $ids[] = $item->ID;
    }

    // Se o array não estiver vazio retorna os ids, senão retorna false
    return count($ids) > 0 ? $ids : false;
}
```

Em seguida usa a função da seguinte forma:

```php
// Monta a Query
$query = new WP_Query([
    'post_type'      => 'post-type-example',
    'post_status'    => 'publish',
    'posts_per_page' => -1
]);

// Obtém os ids
$ids = get_ids($query);

// Aplica a sua lógica
if (is_array($ids) && in_array($ids, $array)) {
    // ...
}
```

Contudo, o Worpress tem a função que resolve o problema de uma forma mais simples, sem precisar implementar a ```get_ids```. Basta apenas passar um ```array``` que possuam os mesmos indíces.

```php
// Monta a Query
$query = new WP_Query([
    'post_type'      => 'post-type-example',
    'post_status'    => 'publish',
    'posts_per_page' => -1
]);

// Obtém os ids
$ids = wp_list_pluck($query->posts, 'ID');

// Aplica a lógica
if (in_array($ids, $array)) {
    // ...
}
```
Além de termos mais um motivo para usar o _atributo posts_ também conseguimos econimizar algumas linhas de código =D

### Atualização da versão e plugins

Por último, mas não menos importante, é importante lembrar para sempre trabalharem com as últimas versões de plugins e do Wordpress, pois é um dos gerenciadores de conteúdo mais usados no mundo e com isso é alvo de muitas tentativas de invasão. Constantemente estão sendo lançadas correções não somente de bugs, mas também de brechas de segurança. A não atualização também gera problemas de compatibilidade com plugins que por sua vez param de funcionar da forma que se espera.

### Considerações

Se você tiver alguma dúvida, sugestão ou crítica fique a vontade para comentar :)





