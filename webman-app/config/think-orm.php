<?php

return [
    'default' => 'mysql',
    'connections' => [
        'mysql' => [
            // Driver type
            'type'        => 'mysql',
            // Server address (phải là tên service trong docker-compose)
            'hostname'    => 'mysql',
            // Database name
            'database'    => 'webman_db',
            // Username
            'username'    => 'webman',
            // Password
            'password'    => '1234',
            // Port
            'hostport'    => '3306',
            // Charset
            'charset'     => 'utf8mb4',
            // Table prefix
            'prefix'      => '',
            // 数据库连接参数
            'params' => [
                // 连接超时3秒
                \PDO::ATTR_TIMEOUT => 3,
            ],
            // 数据库编码默认采用utf8
            'charset' => 'utf8',
            // 断线重连
            'break_reconnect' => true,
            // 自定义分页类
            'bootstrap' =>  '',
            // 连接池配置
            'pool' => [
                'max_connections' => 5, // 最大连接数
                'min_connections' => 1, // 最小连接数
                'wait_timeout' => 3,    // 从连接池获取连接等待超时时间
                'idle_timeout' => 60,   // 连接最大空闲时间，超过该时间会被回收
                'heartbeat_interval' => 50, // 心跳检测间隔，需要小于60秒
            ],
        ],
    ],
];
