---
layout: post
title: "Creating Elementor Widgets"
comments: true
lang: en
ref: creating-elementor-widgets
excerpt:  "The Elementor is a WordPress tool that allows you to build pages dynamically through widgets. It has some widgets but you can make yours. In this article, I will show how to do it. The idea is to create a simple widget to list products and their information."
image: "/images/2021-05-04/elementor-page-builder.png"
feature_text: |
    ## Creating Elementor Widgets
tags:
    - Wordpress
    - Elementor
    - Widgets
---

[Portuguese Version]({{site.baseurl}}/2021/04/30/criando-widgets-para-o-elementor)

The Elementor is a WordPress tool that allows you to build pages dynamically through widgets. It has some widgets but you can make yours. In this article, I will show how to do it. The idea is to create a simple widget to list products and their information.

I will assume you have a WordPress installation with the [Elementor plugin](https://elementor.com/){:target="_blank"} active.

In the first step, you need to create a custom post type for products and add custom fields. I like using [Advanced Custom Fields](https://www.advancedcustomfields.com/){:target="_blank"} to configure fields and associate them with posts type.

![Table showing custom fields data with order, label, name and type]({{site.baseurl}}/images/2021-05-04/fields.png)

To work with Elementor I have a preference to build a plugin to keep the source more organized and using this strategy you can apply in other projects.

To create a plugin, you need to create a directory called `elementor-custom-widgets` inside `wp-content > plugins`. This new directory will have the following structure.

```bash
> tree /wp-content/plugins/elementor-custom-widgets

| - elementor-custom-widgets.php
| - index.php 
| - /widgets
| ---- /products
| -------- index.php
| -------- html.php
| -------- widget.php

```

The `index.php` files only contain comments.

```php
<?php // Silence
```

The `elementor-custom-widgets.php` file configures the plugin and records widgets.

```php 
<?php 

/**
 * Plugin Name: My Custom Widgets
 * Description: My Custom Widgets for Elementor
 * Author:      Fernando Mariano
 * Author URI:  https://fndomariano.github.io
 */

namespace MyCustomWidgets;


class Plugin {

    public function __construct() {
		add_action( 'elementor/widgets/widgets_registered', [ $this, 'register_widgets' ] );		
	}

    private function include_widgets() {		        
		require_once( __DIR__ . '/widgets/products/widget.php' );        
	}

    public function register_widgets() {
		
        $this->include_widgets();
		        
		\Elementor\Plugin::instance()->widgets_manager->register_widget_type( new Widgets\Products() );
	}
 }

 new Plugin();
```

The `/widgets/widget.php` file is the whole widget's settings (controls, icon, title).


```php
<?php

namespace MyCustomWidgets\Widgets;

use Elementor\Controls_Manager;

class Products extends \Elementor\Widget_Base {
    
    public function get_name() {
		return 'products';
	}

    public function get_title() {
		return __( 'Products' );
	}

    public function get_icon() {
		return 'fa fa-pencil';
	}

    public function get_categories() {
		return [ 'general' ];
	}

    protected function _register_controls() {
		
		$this->start_controls_section(
			'section_content',
			[
				'label' => 'Content',
			]
		);

		$this->add_control(
			'number_registers',
			[
				'label' => 'Number registers',
				'type' => Controls_Manager::NUMBER,
				'default' => 5
			]
		);

		$this->end_controls_section();
	}

    protected function render() {
		
		$this->getHtml();
	}
    
	private function getHtml() {
		
		$products = $this->getProducts();

		include 'html.php';
	}
 
	private function getProducts() {

		$settings = $this->get_settings_for_display();

		$paged = ( get_query_var( 'paged' ) ) ? get_query_var( 'paged' ) : 1;

		$query = new \WP_Query([
			'post_type'      => 'product',
			'post_status'    => 'publish',
			'posts_per_page' => $settings['number_registers'],
			'paged'          => $paged
		]);

		return $query;
	}
}
```

The `/widgets/html.php` file is HTML structure integrated with `$query` result.

```php
<?php if ( $products->have_posts() ): ?>

<table>
    <thead>
        <td><b><?php echo 'Photo' ?></b></td>
        <td><b><?php echo 'Name' ?></b></td>
        <td><b><?php echo 'Brand' ?></b></td>
        <td><b><?php echo 'Price' ?></b></td>
    </thead>
    <tbody>
        <tbody>
            <?php while ( $products->have_posts() ) : $products->the_post();  ?>
                
                <?php $photo = get_field('product_photo', get_the_ID()); ?>

                <tr>
                    <td><img src="<?php echo $photo['url'] ?>"  width="<?php echo $photo['sizes']['thumbnail-width'] ?>" height="<?php echo $photo['sizes']['thumbnail-height'] ?>" /></td>
                    <td><?php echo get_the_title() ?></td>
                    <td><?php echo get_field('product_brand', get_the_ID()) ?></td>
                    <td><?php echo get_field('product_price', get_the_ID()) ?></td>
                </tr>
            <?php endwhile; ?>
        </tbody>
    </tbody>
</table>

<?php 
    echo paginate_links( [
        'base'         => str_replace( 999999999, '%#%', esc_url( get_pagenum_link( 999999999 ) ) ),
        'total'        => $products->max_num_pages,
        'current'      => max( 1, get_query_var( 'paged' ) ),
        'format'       => '?paged=%#%',
        'prev_next'    => true,
        'prev_text'    => sprintf( '<i></i> %1$s', __( 'Newer Posts', 'text-domain' ) ),
        'next_text'    => sprintf( '%1$s <i></i>', __( 'Older Posts', 'text-domain' ) ),
    ]); 
?>

<?php else : ?>
    <p><?php _e('Sorry, no posts matched your criteria.'); ?></p>
<?php endif; ?>
```

To apply this widget is necessary to add a new page on WordPress editing with Elementor and search for the word `Products`.

![Searching Products Widget]({{site.baseurl}}/images/2021-05-04/elementor_search.png)

Drag and drop to put the widget on the page. Also, control allows the definition of many products to show.

![Products Widget Control]({{site.baseurl}}/images/2021-05-04/elementor_control.png)

If you don't have products, add some of them and like this will be possible to see the changes in the same moment. 

![Table of products showing four registers with photo, name, brand and price]({{site.baseurl}}/images/2021-05-04/products.png)


I hope that I could show how easy it is to build an Elementor widget. The [codes above are available on my GitHub](https://github.com/fndomariano/elementor-custom-widgets){:target="_blank"}.

Is there still any doubt? Please let me know! I will be happy to help you.