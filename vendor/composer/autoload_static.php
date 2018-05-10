<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInitf7bcaf88814232fa6202e75e65efaeed
{
    public static $prefixLengthsPsr4 = array (
        'P' => 
        array (
            'Psr\\Log\\' => 8,
        ),
        'C' => 
        array (
            'Carbon\\Interfaces\\' => 18,
            'Carbon\\Helpers\\' => 15,
            'Carbon\\Error\\' => 13,
            'Carbon\\' => 7,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Psr\\Log\\' => 
        array (
            0 => __DIR__ . '/..' . '/psr/log/Psr/Log',
        ),
        'Carbon\\Interfaces\\' => 
        array (
            0 => __DIR__ . '/../..' . '/Interfaces',
        ),
        'Carbon\\Helpers\\' => 
        array (
            0 => __DIR__ . '/../..' . '/Helpers',
        ),
        'Carbon\\Error\\' => 
        array (
            0 => __DIR__ . '/../..' . '/Error',
        ),
        'Carbon\\' => 
        array (
            0 => __DIR__ . '/../..' . '/Structure',
        ),
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInitf7bcaf88814232fa6202e75e65efaeed::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInitf7bcaf88814232fa6202e75e65efaeed::$prefixDirsPsr4;

        }, null, ClassLoader::class);
    }
}