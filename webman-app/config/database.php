<?php

return [
    'default'     => 'mysql',
    'connections' => [
        'mysql' => [
            'type'        => 'mysql',
            'hostname'    => env('DB_HOST', 'mysql'),
            'database'    => env('DB_DATABASE', 'webman_db'),
            'username'    => env('DB_USERNAME', 'webman'),
            'password'    => env('DB_PASSWORD', '1234'),
            'hostport'    => env('DB_PORT', '3306'),
            'charset'     => 'utf8mb4',
            'prefix'      => '',
        ],
    ],
];
