---
layout: post
title: "Criando widgets para o Elementor"
comments: true
lang: br
ref: criando-widgets-para-o-elementor
excerpt:  "O Elementor é uma ferramenta do WordPress que permite você construir páginas dinamicamente atráves de widgets. Ele tem alguns widgets, mas você pode criar os seus. Neste artigo pretendo mostrar como fazer. A ideia é criar um widget simples para listar produtos e suas informações."
image: "/images/2021-05-04/elementor-page-builder.png"
feature_text: |
    ## Criando widgets para o Elementor
tags:
    - Wordpress
    - Elementor
    - Widgets
---

[Versão em Inglês]({{site.baseurl}}/2021/04/05/creating-elementor-widgets)

O Elementor é uma ferramenta do WordPress que permite construir páginas dinamicamente atráves de widgets. Ele tem alguns _widgets_, mas você pode criar os seus. Neste artigo pretendo mostrar como fazer. A ideia é criar um _widget_ simples para listar produtos e suas informações.

Vou assumir que você tenha uma instalação do WordPress com o [plugin do Elementor](https://elementor.com/){:target="_blank"} ativo.

O primeiro passo, você precisa criar um CPT (_Custom Post Type_) para os produtos e adicionar campos customizáveis. Eu gosto de usar o [plugin Advanced Custom Fields](https://www.advancedcustomfields.com/){:target="_blank"} para confugurar os campos e associar aos CPTs.

![Tabela mostrando campos customizáveis com order, label, name e type]({{site.baseurl}}/images/2021-05-04/fields.png)

Para trabalhar com o Elementor eu tenho preferência por construir um plugin para deixar mais organizado e com essa estratégia você pode usá-lo em outros projetos.

Para criar um _plugin_, você precisa criar um diretório chamando `elementor-custom-widgets` dentro de `wp-content > plugins`. Este novo diretório vai possui a seguinte estrutura.

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

Os arquivos `index.php` contém apenas comentários.

```php
<?php // Silence
```

O arquivo `elementor-custom-widgets.php` configura o plguin e registra os _widgets_.

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

    public function _construct() {
		add_action( 'elementor/widgets/widgets_registered', [ $this, 'register_widgets' ] );		
	}

    private function include_widgets() {		        
		require_once( _DIR_ . '/widgets/products/widget.php' );        
	}

    public function register_widgets() {
		
        $this->include_widgets();
		        
		\Elementor\Plugin::instance()->widgets_manager->register_widget_type( new Widgets\Products() );
	}
 }

 new Plugin();
```

O arquivo `/widgets/widget.php` está toda a configuração de um _widget_ (_controls_, _icon_, _title_).

```php
<?php

namespace MyCustomWidgets\Widgets;

use Elementor\Controls_Manager;

class Products extends \Elementor\Widget_Base {
    
    public function get_name() {
		return 'products';
	}

    public function get_title() {
		return _( 'Products' );
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

O arquivo `/widgets/html.php` é a estrutura HTML integrada com o resultado de `$query`.

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
        'prev_text'    => sprintf( '<i></i> %1$s', _( 'Newer Posts', 'text-domain' ) ),
        'next_text'    => sprintf( '%1$s <i></i>', _( 'Older Posts', 'text-domain' ) ),
    ]); 
?>

<?php else : ?>
    <p><?php _e('Sorry, no posts matched your criteria.'); ?></p>
<?php endif; ?>
```
Para aplicar este widget é necessário adicionar uma nova página no WordPress editando com Elementor e buscar pela palavra `Products`

![Procurando pelo widget Products]({{site.baseurl}}/images/2021-05-04/elementor_search.png)

Arrastando e soltando é possivel colocar o _widget_ na página. Um controle permite definir um número de produtos para exibir.

![Controle do widget Products]({{site.baseurl}}/images/2021-05-04/elementor_control.png)

Se você não tem produtos, adicione alguns deles e assim será possível ver as mudanças acontecerem no mesmo momento.

![Tabela de produtos exibindo quatro registros com foto, nome, marca e preço]({{site.baseurl}}/images/2021-05-04/products.png)

Eu espero ter conseguido mostrar quão fácil é contruir um _widget_ para o Elementor. Os [códigos acima estão disponíveis no meu GitHub](https://github.com/fndomariano/elementor-custom-widgets){:target="_blank"}.

Ainda ficou com dúvidas? Por favor, me avise. Ficarei feliz em ajudar você!