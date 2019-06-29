---
layout:    post
title:    "Wordpress Development Tips"
comments: true
lang: en
ref: wordpress-development-tips
excerpt:  "This text is a few different from previous texts where I've talked about data subjects. Here I intent to illustrate some tips on projects wordpress development."
feature_image: "/images/2019-04-06/wordpress-header.jpg"
tags:
    - wordpress
    - php
---

[Portuguese Version]({{site.url}}/2019/04/06/dicas-desenvolvimento-wordpress)

This text is a few different from previous texts where I've talked about data subjects. Here I intent to illustrate some tips on projects Wordpress development.

### Transaction

Many times we need to import data that will be used to show in any project. The importation process can generate some errors when is running, thus, we need to ensure that in this cases don't be imported incomplete information. Therefore, for these situations is correct to use ```transactions```. Of course, there are many purposes which don't have relation with importation tasks.

```php 
function addPostExample() {

    // Global variable from Wordpress
    global $wpdb; 
    
    // I start the transtation
    $wpdb->query('START TRANSACTION');
    
    // I define some data for the post
    $postData = [
        'post_title'     => 'Title example',  
        'post_type'      => 'post-type-example',
        'post_status'    => 'publish',
        'comment_status' => 'closed',
        'ping_status'    => 'closed'
    ];
    
    // The post is recorded
    $postExample = wp_insert_post($postData, true);

    // Is there some error?
    if (is_wp_error($postExample)) {
        
        // If yes, we do rollback
        $wpdb->query('ROLLBACK');
        return;
    } 
    
    // Is not there an error? Then is save the post
    $wpdb->query('COMMIT');
        
    // Returns the post id
    return $postExample;
}
```

### Truncate text

A situation that happens many times is when we need to show only part of the content (ie preview to text from the blog). 

I worked in projects where developers built a function to cut content by the quantity of the words, but there would have no necessity because the Wordpress has a function that does that.


```php
$text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In suscipit convallis neque non suscipit. Nunc interdum ultrices ultrices. Interdum et malesuada fames ac ante ipsum primis in faucibus. Donec id justo tincidunt, porta mi vitae, sodales nibh. Nulla quis velit at erat maximus porta. Mauris sit amet consequat ligula. Vivamus congue pretium fermentum. Duis non lorem sodales, aliquam sapien quis, sodales elit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vestibulum ut ex ultricies, iaculis velit a, suscipit sem. Maecenas pharetra est vitae ipsum posuere, ac elementum lorem condimentum. Maecenas congue ac magna euismod euismod.';

echo wp_trim_words($text, $numWords = 10, '...');

```
On the code above is used the function ```wp_trim_words``` which has three arguments. The first is the text (Lorem Ipsum) that will be cut, the second argument means the number of words which will be showed and the last is what will be concatenated with words. The o result is going to be like this:

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In suscipit...
```

### Use the _posts attribute_

Another situation that happens on Wordpress projects is we found queries with ```WP_Query``` and after that is used ```while``` to show the results. See the example below:

```php
<?php 

// I built the query
$query = new WP_Query([
    'post_type'      => 'post-type-example',
    'post_status'    => 'publish',
    'posts_per_page' => 5
]);

?>

// I verify if there are posts and after I merge posts with HTML
<?php if ($query->have_posts()): ?>
    <ul>
        <?php while ($query->have_posts()): $query->the_post(); ?>
            <li><?php echo get_the_title() ?></li>
        <?php endwhile ?>
    </ul>
    
    // I reset the query to avoid conflicts with other queries
    <?php wp_reset_postdata() ?>
<?php endif ?>
```
Now, an example using the _posts attribute_. The object ```WP_Query``` has the _posts attribute_ which is an ```array``` and we can use with ```foreach``` as the ```PHP``` suggests.

```php
<?php 

// I built the query
$query = new WP_Query([
    'post_type'      => 'post-type-example',
    'post_status'    => 'publish',
    'posts_per_page' => 5
]);

?>

// I verify if there are posts and after I merge posts with HTML
<?php if ($query->posts): ?>
    <ul>
        <?php foreach ($query->posts as $item): ?>
            <li><?php echo $item->post_title ?></li>
        <?php endforeach ?>
    </ul>	
<?php endif ?>
```
From my point of view, with this approach get simpler to read the code.

### Function _wp_list_pluck_ 

Another situation that I found out in many projects was the logic from the developer would need to verify if a set of IDs from a query were within an ```array```. Until this point is ok, but to get the IDs the developer created a function where was returned another ```array``` only with IDs. As in the following example.

```php
// Function that returns IDs
function get_ids($query) {

    // if there are no posts
    if (!$query->posts) {
        return false;
    }

    // clear array to insert IDs
    $ids = [];

    // read posts using posts attribute =D
    foreach ($query->posts as $item) {
        
        // Insert IDs in array
        $ids[] = $item->ID;
    }

    // if the array is not clear then returns the IDs, else return false
    return count($ids) > 0 ? $ids : false;
}
```

Then, he uses the function like this:

```php
// He built the query
$query = new WP_Query([
    'post_type'      => 'post-type-example',
    'post_status'    => 'publish',
    'posts_per_page' => -1
]);

// Get the IDs
$ids = get_ids($query);

// He applies his logic
if (is_array($ids) && in_array($ids, $array)) {
    // ...
}
```
However, the Wordpress has a function that figures out the problem with way easier, without to need to implement the ```get_ids```. Is only put an array as an argument and this ```array``` needs to have the same indexes.

```php
// Built de query
$query = new WP_Query([
    'post_type'      => 'post-type-example',
    'post_status'    => 'publish',
    'posts_per_page' => -1
]);

// Get the IDs
$ids = wp_list_pluck($query->posts, 'ID');

// Apply the logics
if (in_array($ids, $array)) {
    // ...
}
```
Beyond we have one more reason to use the _posts attribute_ also we can save some code lines =D

### Update version and plugins

And for last, but not less important, is important you remember to work with the last version of the plugins and Wordpress because it is one of the content managers more used in the world and like that is a target of many hacker's attacks. Constantly are launched security and bugs corrections. If you don't update, there are great chances of you have problems with compatibility with plugins and they stop working as you hope.

### Considerations

If you have some doubt, suggestion or critics, feel free to comment :)






