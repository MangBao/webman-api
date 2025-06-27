<?php
require_once __DIR__ . '/config/bootstrap.php';

return [
    'analyser' => OpenApi\Analysers\ReflectionAnalyser::class,
    'paths' => [
        'app',
    ],
];
