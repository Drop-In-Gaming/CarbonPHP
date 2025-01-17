<?php
/* Create a new class called Bcrypt */
/*
 *
*/

namespace CarbonPHP\Abstracts;

use CarbonPHP\Error\PublicAlert;

abstract class Bcrypt
{
    private static $rounds = 10;


    // http://php.net/manual/en/language.operators.bitwise.php
    // in actual system we will have to see what bit system we are using
    // 32 bit = 28
    // 64 biit = 60
    // I assume this means php uses 4 bits to denote type (vzal) ?
    // idk
    // godaddy has me on a 64 bit computer
    public static function genRandomHex($bitLength = 40): string
    {
        $sudoRandom = 1;
        for ($i=0;$i<=$bitLength;$i++) {
            /** @noinspection PhpUnhandledExceptionInspection */
            $sudoRandom = ($sudoRandom << 1) | random_int(0, 1);
        }
        return dechex($sudoRandom);
    }
    
    private static function genSalt()
    {
        /* GenSalt */
        $string = str_shuffle( mt_rand() );
        return uniqid( $string, true );
    }

    /**
     * @param $password
     * @return string|null
     * @throws PublicAlert
     */
    public static function genHash($password): ?string
    {
        if (CRYPT_BLOWFISH !== 1) {
            throw new PublicAlert('Bcrypt is not supported on this server, please see the following to learn more: http://php.net/crypt');
        }

        /* Explain '$2y$' . $this->rounds . '$' */
        /* 2y selects bcrypt algorithm */
        /* $this->rounds is the workload factor */
        /* GenHash */
        /* Return */
        return crypt( $password, '$2y$' . self::$rounds . '$' . self::genSalt() );
    }

    /* Verify Password */
    /**
     * @param $password
     * @param $existingHash
     * @return bool
     */
    public static function verify($password, $existingHash): bool
    {
        /* Hash new password with old hash */

        $hash = crypt( $password, $existingHash );

        /* Do Hashes match? */
        return $hash === $existingHash;
    }
}