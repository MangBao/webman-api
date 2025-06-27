<?php

use Webman\Route;
use Webman\Http\Response;

Route::get('/swagger/ui', function () {
    return new Response(302, ['Location' => '/swagger/ui/index.html']);
});
