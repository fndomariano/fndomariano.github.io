---
layout: default
title: {{ site.name }}
---

<div id="home">
    <h1>Últimos posts</h1>
    {% for post in site.posts %}
        <h2><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></h2>
        {{ post.excerpt }}... 
  
        {% if post.excerpt != post.content %}
            <a href="{{ site.baseurl }}{{ post.url }}">Continue lendo</a>
        {% endif %}

        <hr/>

    {% endfor %}
</div>