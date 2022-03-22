---
layout: post
title: "Como testar arquivos usando Laravel?"
comments: true
lang: br
ref: como-testar-arquivos-usando-laravel
excerpt:  "Alguns meses atrás eu estava trabalhando em um projeto usando Laravel e o mesmo possui upload de arquivos. Desde que eu comecei a desenvolver fazendo o uso de testes automatizados, eu nunca tinha tido a oportunidade de construí-los com arquivos. Então eu desconbri que o Laravel fornece uma forma bem fácil de criar aquivos fake nos testes."
feature_text: |
    ## Como testar arquivos usando Laravel?
tags:
    - Laravel
    - upload
    - php
    - testes
---

[Versão em Inglês]({{site.baseurl}}/2022/03/22/how-to-make-tests-with-files-on-laravel)

Alguns meses atrás eu estava trabalhando em um projeto usando Laravel e o mesmo possui upload de arquivos. [Desde que eu comecei a desenvolver fazendo o uso de testes automatizados]({{site.baseurl}}/2021/01/03/a-historia-do-desenvolvedor-que-nao-custumava-usar-testes-automatizados), eu nunca tinha tido a oportunidade de construí-los com arquivos. Então eu desconbri que o Laravel fornece uma forma bem fácil de criar aquivos _fake_ nos testes.

Minha intenção aqui é mostrar como podemos criar alguns testes para validar aquivos usando o Laravel.

> Falar é fácil. Me mostre o código.
>
> -- <cite>Linus Torvalds</cite>

Para este arquivo, eu crei um novo projeto Laravel com um _endpoint_ bem simples.

```php
Route::post('/documents/new', function (Request $request) {
   
    $validator = Validator::make($request->all(), [
        'file' => 'required|mimes:pdf|max:2048'
    ]);  
 
    if ($validator->fails()) {
        return response()->json(['error' => $validator->errors()], 400);
    }
 
    return response()->json(['success' => 'Congratulations!'], 200);
});
```
Para a requisição ser bem sucedida, a rota está esperando um arquivo pdf e o tamanho dele precisa ser menor que 2048 KB ou 2 MB.

Está na hora do teste!!!

![Uma pessoa fantasiada batendo ao lado do carro com sua mão]({{site.baseurl}}/images/2022-03-21/car_test.gif)

No inicio, falei sobre a uma forma que o Laravel fornece para os desenvolvedores testarem arquivos. O framework possui a classe `Illuminate\Http\UploadedFile` que é muito simples de usar. Eu criei três testes. O primeiro é para para sucesso, o segundo verifica se o arquivo possui uma extensão válida e o último valida o tamanho do arquivo.

```php
class UploadExampleTest extends TestCase
{
    /**
     * Deve retornar o código 200.
     *
     * @return void
     */
    public function test_the_upload_returns_a_successful_response()
    {
        $document = UploadedFile::fake()->create('tests/test.pdf');
       
        $response = $this->post('/api/documents/new', ['file' => $document]);
 
        $response->assertStatus(200);
    }
 
    /**
     * Deve retornar o código 400 por causa da extensão do arquivo.
     *
     * @return void
     */
    public function test_the_upload_returns_a_bad_request_cause_file_extension()
    {
        $document = UploadedFile::fake()->create('tests/test.txt');
       
        $response = $this->post('/api/documents/new', ['file' => $document]);
 
        $response->assertStatus(400);
    }

    /**
     * Deve retornar o código 400 por causa do tamanho do arquivo.
     *
     * @return void
     */
    public function test_the_upload_returns_a_bad_request_cause_file_size()
    {
        $document = UploadedFile::fake()->create('tests/test.pdf', 5120);
       
        $response = $this->post('/api/documents/new', ['file' => $document]);
 
        $response->assertStatus(400);
    }
}
```
O que eu quero destacar é `UploadFile::fake()->create(‘tests/test.pdf’, 5120)`. O primeiro argumento, você define exatamente o nome do arquivo a extensão. No segundo, você configura qual o tamanho do arquivo que você quer. Muito fácil, não?

Se você conhece alguma forma diferente de fazer, deixe seu comentário. Compartilhar conhecimento é sempre bom :)