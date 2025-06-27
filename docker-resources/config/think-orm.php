<?php

return [
    'default' => 'mysql',
    'connections' => [
        'mysql' => [
            'type'        => 'mysql',
            'hostname'    => getenv('DB_HOST') ?: '127.0.0.1',
            'database'    => getenv('DB_DATABASE') ?: 'webman_db',
            'username'    => getenv('DB_USERNAME') ?: 'root',
            'password'    => getenv('DB_PASSWORD') ?: '',
            'hostport'    => getenv('DB_PORT') ?: '3306',
            'charset'     => getenv('DB_CHARSET') ?: 'utf8mb4',
            'prefix'      => '',
            'params' => [
                \PDO::ATTR_TIMEOUT => 3,
            ],
            'break_reconnect' => true,
            'bootstrap' => '',
            'pool' => [
                'max_connections' => 5,
                'min_connections' => 1,
                'wait_timeout' => 3,
                'idle_timeout' => 60,
                'heartbeat_interval' => 50,
            ],
        ],
    ],
];
