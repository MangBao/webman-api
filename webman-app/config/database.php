<?php

return [
    'default'     => 'mysql',
    'connections' => [
        'mysql' => [
            'type'        => 'mysql',
            'hostname' => getenv('DB_HOST') ?: 'mysql',
            'database' => getenv('DB_DATABASE') ?: 'webman_db',
            'username' => getenv('DB_USERNAME') ?: 'webman',
            'password' => getenv('DB_PASSWORD') ?: '1234',
            'hostport' => getenv('DB_PORT') ?: '3306',
            'charset'     => 'utf8mb4',
            'prefix'      => '',
        ],
    ],
];
