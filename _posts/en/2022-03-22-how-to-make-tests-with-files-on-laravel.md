---
layout:    post
title:    "How to make tests with files on Laravel?"
comments: true
lang: en
ref: how-to-make-tests-with-files-on-laravel
excerpt:  "Some days ago, I was working on a Laravel project that runs with uploads. Since I’ve started programming using automated tests I never had an opportunity to build them with files. Then I found out that Lavarel provides a way to work them in tests."
image: "/images/2022-03-21/laravel.png"
feature_text: |
    ## How to make tests with files on Laravel?
tags:
    - Laravel
    - upload
    - php
    - tests
---

[Portuguese Version]({{site.baseurl}}/2022/03/22/como-testar-arquivos-usando-laravel)

Some months ago, I was working on a Laravel project that runs with uploads. [Since I’ve started programming using automated tests]({{site.baseurl}}/2021/01/03/the-developer-story-did-not-use-to-implement-automated-tests) I never had an opportunity to build them with files. Then I found out that Lavarel provides a way to work with fake files in tests. 

My intent here is to show how we can create some tests to validate files using Laravel. 

> Talk is cheap. Show me the code.
>
> -- <cite>Linus Torvalds</cite>

For this article, I created a new Laravel project with a simple endpoint. 

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
To be a successful request, the route is expecting a pdf file and its size can’t be greater than 2048 KB or 2 MB.

It’s test time!!!

![A custom person hitting a side the car with their hand]({{site.baseurl}}/images/2022-03-21/car_test.gif)

In the beginning, I spoke about a way Laravel provides for developers to make tests. At its core, there is `Illuminate\Http\UploadedFile` which is very easy to use. I created three tests. The first one is successful, the second one verifies the file extension and the last one validates the file size.

```php
class UploadExampleTest extends TestCase
{
    /**
     * It must return response 200.
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
     * It must return response 400 cause of the file extension.
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
     * It must return response 400 cause of the file size.
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

What I want to highlight is `UploadFile::fake()->create(‘tests/test.pdf’, 5120)`. In the first argument, you set exactly the name and extension you need. In the second one, you can define the size of the file. Is it pretty simple, isn't it?

If you know a different way to build tests with files, let me know. Sharing knowledge is always good :)