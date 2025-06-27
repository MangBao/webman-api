<?php

use Webman\Route;

// 📌 Đảm bảo bạn đã `require` file này trong `config/route.php`
Route::get('/swagger/ui', function () {
    return response()->redirect('/swagger/ui/index.html');
});
