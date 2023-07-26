<?php

// http://php.net/manual/en/function.debug-backtrace.php

namespace CarbonPHP\Error;

use CarbonPHP\CarbonPHP;
use CarbonPHP\Database;
use CarbonPHP\Enums\ThrowableReportDisplay;
use CarbonPHP\Helpers\Background;
use CarbonPHP\Helpers\ColorCode;
use CarbonPHP\Helpers\Files;
use CarbonPHP\Interfaces\iColorCode;
use CarbonPHP\Rest;
use CarbonPHP\Tables\Reports;
use Error;
use PDOException;
use ReflectionException;
use ReflectionMethod;
use Throwable;

/**
 * This is really an Error and Exception handler
 *
 * Class ErrorCatcher
 * @package CarbonPHP\Error
 *
 * Provide a global error and exception handler.
 *
 */
class ThrowableHandler
{

    public const LOG_ARRAY = 'LOG_ARRAY';

    public const HTML_ERROR_PAGE = 'HTML_ERROR_PAGE';

    public const STORED_HTML_LOG_FILE_PATH = 'STORED_HTML_LOG_FILE_PATH';

    public const STORAGE_LOCATION_KEY = 'THROWABLE STORED TO FILE';

    public const TRACE = 'TRACE';
    public const GLOBALS_JSON = '$GLOBALS[\'json\']';
    public const INNODB_STATUS = 'INNODB_STATUS';
    public const DEBUG_BACKTRACE = 'debug_backtrace()';

    // todo - defaultLocation this does nothing.
    public static ?string $defaultLocation = null;
    /**
     * @var bool $printToScreen determine if a generated error log should be shown on the browser.
     * This value can be set using the ["ERROR"]["SHOW"] configuration option
     */
    public static bool $printToScreen = true;

    public static bool $bypass_standard_PHP_error_handler = true;


    /**
     * @var bool
     */
    public static bool $storeReport = false;

    public static ThrowableReportDisplay $throwableReportDisplay = ThrowableReportDisplay::FULL_DEFAULT;

    public static string $fileName = '';

    public static string $className = '';

    public static string $methodName = '';

    // The following two should be of type   ?Closure|array
    // @link https://www.php.net/manual/en/function.set-error-handler.php
    public static mixed $old_error_handler = null;

    public static mixed $old_exception_handler = null;

    public static ?int $old_error_level = null;

    public static bool $attemptRestartAfterError = false;

    public static string $errorTemplate = <<<DEVOPS
            <html lang="en">
            <head>
            <style>
            @import url("https://fonts.googleapis.com/css?family=Share+Tech+Mono|Montserrat:700");
            
            * {
                margin: 0;
                padding: 0;
                border: 0;
                font-size: 100%;
                vertical-align: baseline;
                box-sizing: border-box;
                color: inherit;
            }
            
            html { 
              background: url("{{carbon_public_root}}/view/assets/img/Carbon-teal.png") no-repeat center center fixed; 
              -webkit-background-size: cover;
              -moz-background-size: cover;
              -o-background-size: cover;
              background-size: cover;
            }
            
            body {
                height: 100vh;
            }
            
            h1 {
                font-size: 45vw;
                text-align: center;
                position: fixed;
                width: 100vw;
                z-index: 1;
                color: #ffffff26;
                text-shadow: 0 0 50px rgba(0, 0, 0, 0.07);
                top: 50%;
                transform: translateY(-50%);
                font-family: "Montserrat", monospace;
            }
            
            div {
                background-color: rgba(1,1,1,0.9);
                width: 70vw;
                overflow: scroll;
                max-height: 80%;
                position: relative;
                top: 50%;
                transform: translateY(-50%);
                margin: 0 auto;
                padding: 30px 30px 10px;
                box-shadow: 0 0 150px -20px rgba(0, 0, 0, 0.5);
                z-index: 3;
            }
            
            P {
                font-family: "Share Tech Mono", monospace;
                color: #f5f5f5;
                margin: 0 0 20px;
                font-size: 17px;
                line-height: 1.2;
            }
            
            span {
                color: #f0c674;
            }
            
            i {
                color: #8abeb7;
            }
            
            div a {
                text-decoration: none;
            }
            
            b {
                color: #81a2be;
            }
            
            a.avatar {
                position: fixed;
                bottom: 15px;
                right: -100px;
                animation: slide 0.5s 4.5s forwards;
                display: block;
                z-index: 4
            }
            
            a.avatar img {
                border-radius: 100%;
                width: 44px;
                border: 2px solid white;
            }
            
            @keyframes slide {
                from {
                    right: -100px;
                    transform: rotate(360deg);
                    opacity: 0;
                }
                to {
                    right: 15px;
                    transform: rotate(0deg);
                    opacity: 1;
                }
            }
            
            pre {
              background-color:rgba(18,18,18,0.9);
              max-height: 30%;
              overflow:scroll;
              margin:0 0 1em;
              padding:.5em 1em;
            }
            
            ::-webkit-scrollbar {
              -webkit-appearance: none;
              width: 10px;
            }
            
            ::-webkit-scrollbar-thumb {
              border-radius: 5px;
              background-color: rgba(0,255,252,0.5);
              -webkit-box-shadow: 0 0 1px rgba(0,255,252,0.5);
            }
            
            pre code,
            pre .line-number {
              /* Ukuran line-height antara teks di dalam tag <code> dan <span class="line-number"> harus sama! */
              font:normal normal 12px/14px "Courier New",Courier,Monospace;
              color:black;
              display:block;
            }
            
            pre .line-number {
              float:left;
              margin:0 1em 0 -1em;
              border-right:1px solid;
              text-align:right;
            }
            
            pre .line-number span {
              display:block;
              padding:0 .5em 0 1em;
            }
            
            pre .cl {
              display:block;
              clear:both;
            }
            </style>
            <script src="{{carbon_public_root}}/node_modules/jquery/dist/jquery.slim.min.js"></script>
            <script src="{{carbon_public_root}}/node_modules/jquery-backstretch/jquery.backstretch.min.js"></script>
            <script>
            (function() {
                var pre = document.getElementsByTagName('pre'),
                    pl = pre.length;
                for (var i = 0; i < pl; i++) {
                    pre[i].innerHTML = '<span class="line-number"></span>' + pre[i].innerHTML + '<span class="cl"></span>';
                   
                    let regExp = /\\n /;
                    
                    var num = pre[i].innerHTML.split(regExp).length;
                    for (var j = 0; j < num; j++) {
                        var line_num = pre[i].getElementsByTagName('span')[0];
                        line_num.innerHTML += '<span>' + (j + 1) + '</span>';
                    }
                }
            })();
            </script>
            </head>
            <body>
            <h1>{{{code}}}</h1>
            <div>
            <p>> <span>HTTP RESPONSE</span>: "<i>HTTP {{{code}}} {{{statusText}}}</i>"</p>
            <p>> <span>{{{actual_message}}}}</span>: "<i>{{{actual_message_body}}}</i>"</p>
            {{{cleanErrorReport}}}
            </div>
            </div>
            <a class="avatar" href="/" title="Go Home"><img src="{{carbon_public_root}}/view/assets/img/Carbon-white.png"/></a>
            </body>
            </html>
            DEVOPS;

    /**
     * @var int to be used with error_reporting()
     * @link http://php.net/manual/en/function.error-reporting.php
     */
    public static int $level = E_ALL | E_STRICT;

    /** Attempt to safely catch errors, output, and public alerts in a closure.
     *
     * @param callable $lambda
     * @return callable
     */
    public static function catchErrors(callable $lambda): callable
    {
        return static function (...$argv) use ($lambda) {

            try {

                ob_start(null, 0, PHP_OUTPUT_HANDLER_CLEANABLE | PHP_OUTPUT_HANDLER_FLUSHABLE | PHP_OUTPUT_HANDLER_REMOVABLE);

                $argv = \call_user_func_array($lambda, $argv);

            } catch (Throwable $e) {

                if (!$e instanceof PublicAlert) {

                    $message = 'Developers make mistakes, and you found a big one! We\'ve logged this event and will be investigating soon.';

                    if (CarbonPHP::$app_local) {

                        PublicAlert::info($message);

                        PublicAlert::danger(\get_class($e) . ' ' . $e->getMessage());

                    } else {

                        PublicAlert::danger($message);
                    }

                    try {

                        ThrowableHandler::generateLog($e);

                    } catch (Throwable $e) {

                        PublicAlert::danger('Error handling failed.');

                        print $e->getMessage();

                        PublicAlert::info(json_encode($e));

                    }
                }

                $argv = null;

            } finally {

                if (ob_get_status() && ob_get_length()) {

                    $out = ob_get_clean();

                    print <<<END
                                <div class="container">
                                <div class="callout callout-info" style="margin-top: 40px">
                                <h4>You have printed to the screen while within the catchErrors() function!</h4>
                                Don't slip up in your production code!
                                <a href="http://carbonphp.com/">Note: All MVC routes are wrapped in this function. Output to the browser should be done within the view! Use this as a reporting tool only.</a>
                                </div><div class="box"><div class="box-body">$out</div></div></div>
                                END;

                }

                Database::verify();     // Check that all database commit chains have finished successfully, otherwise attempt to remove

                return $argv;
            }
        };
    }

    public static function checkCreateLogFile(string &$message): void
    {

        $directory = dirname(self::$defaultLocation);

        if (false === is_dir($directory) && (false === mkdir($directory, 0755, true) || false === is_dir($directory))) {

            throw new PublicAlert('The directory (' . $directory . ') for ThrowableHandler::$defaultLocation (' . self::$defaultLocation . ') does not exist and could not be created');

        }

        if (false === touch(self::$defaultLocation)) {

            $message .= "\n\nCould not create file (" . self::$defaultLocation . ') as it does not exist on the system. All folders appear correct. Please create the directories required to store logs correctly!' . PHP_EOL;

        }

    }

    public static function grabFileSnippet(string $file, int $line, bool $raw = false)
    {
        if (file_exists($file)) {

            // todo - does this work when negative
            $start_line = $line - 10;

            $source = file_get_contents($file);

            $source = preg_split('/' . PHP_EOL . '/', $source);

            if (false === function_exists('highlight')) {

                include_once CarbonPHP::CARBON_ROOT . 'Functions.php';

            }

            $snippet = array_slice($source, $start_line, 20);

            if ($raw) {

                return $snippet;

            }

            return highlight(implode(PHP_EOL, $snippet), true);

        }

        return '';

    }

    public static function grabCodeSnippet(): string
    {
        if (self::$className === '' || self::$methodName === '') {
            return '';
        }

        try {

            $func = new ReflectionMethod(self::$className, self::$methodName);

            $comment = $func->getDocComment();

        } catch (ReflectionException) {

            return '<div>Failed to load code preview in ThrowableHandler class using ReflectionMethod.<div>';

        }

        $f = $func->getFileName(); // stub says string but may also produce false

        if (empty($f)) {
            return '';
        }

        $start_line = $func->getStartLine() - 1;

        $end_line = $func->getEndLine();

        $length = $end_line - $start_line;

        $source = file_get_contents($f);

        $source = preg_split('/' . PHP_EOL . '/', $source);

        if (false === function_exists('highlight')) {

            include_once CarbonPHP::CARBON_ROOT . 'Functions.php';

        }

        return highlight($comment . PHP_EOL . implode(PHP_EOL, array_slice($source, $start_line, $length)), true, $start_line);

    }

    public static function shouldSendJson(): bool
    {
        return $_SERVER["CONTENT_TYPE"] === 'application/json'
            || 'XMLHttpRequest' === ($_SERVER["HTTP_X_REQUESTED_WITH"] ?? '')
            || strpos($_SERVER["CONTENT_TYPE"], 'application/json');
    }


    public static function exitAndSendBasedOnRequested(array $json, string $html = null): never
    {

        $_SERVER["CONTENT_TYPE"] ??= '';

        $sendJson = self::shouldSendJson();

        if (false === headers_sent($file, $line)) {

            $code = $json['CODE'] ?? false;

            if (false === $code || false === is_numeric($code) || $code < 100 || $code > 599) {

                $code = 400;

            }

            $_SERVER["CONTENT_TYPE"] = $sendJson
                ? 'application/json'
                : 'text/html';

            $contentType = 'Content-Type: ' . $_SERVER["CONTENT_TYPE"];

            header($contentType, true, $code);

        } else {

            $json['HEADER_WARNING'] = 'Headers already sent in ' . $file . ' on line ' . $line . '! This can effect the desired response code.';

            $html = ThrowableHandler::generateBrowserReport($json, true);

        }

        if ($sendJson) {

            /** @noinspection JsonEncodingApiUsageInspection */
            $jsonEncoded = json_encode($json, JSON_PRETTY_PRINT);

            if (false === $jsonEncoded) {

                sortDump(['FAILED TO JSON ENCODE THE FOLLOWING (Retrying with sortDump) ::', $json]);

            }

            print $jsonEncoded;

        } else {

            print $html ?? ThrowableHandler::generateBrowserReport($json, true);

        }

        self::closeStdoutStderrAndExit(1);

    }


    /**
     * This terminates!
     * @param array $errorForTemplate
     */
    public static function generateBrowserReport(array $errorForTemplate, bool $return = false): string
    {
        static $count = 0, $error_page = '';

        if (1 < $count++) {

            $errorForTemplate['DANGER'] = 'A possible recursive error has occurred in (or at least affecting) your $app->defaultRoute();';

        }

        $errorForTemplate['CODE'] ??= '0';

        $code = ($errorForTemplate['CODE'] === '0') ? 400 : $errorForTemplate['CODE'];

        if (is_string($code)) {

            if (is_numeric($code)) {

                $code = (int)$code;

            } else {

                $code = 400;

            }

        }

        $error_page = self::errorTemplate($errorForTemplate, $code);

        if ($return) {

            return $error_page;

        }

        // try resetting to the default page if conditions correct, we've already generated a log and optionally printed
        if (!CarbonPHP::$setupComplete) {

            self::exitAndSendBasedOnRequested($errorForTemplate, $error_page);

        }

        // this causes this ::  View::$forceWrapper = true;
        // which breaks the recursive check ?? or does it,
        // we would still need to make it to the view
        // so it only break when we reach the view? todo - test? -- found error in wp finally, we need a default route check here.. or at least a .... startapplication check application === null? __destruct check

        if (CarbonPHP::$application !== null && self::$attemptRestartAfterError && $count === 1) {

            CarbonPHP::resetApplication();  // we're in prod and we want to recover gracefully...

            self::closeStdoutStderrAndExit(1);

        }

        self::exitAndSendBasedOnRequested($errorForTemplate, $error_page);

    }

    /**
     * ThrowableHandler constructor.
     * @return int
     */
    public static function start(): int
    {

        // @link https://stackoverflow.com/questions/60000391/php-missing-function-arguments-in-exception-stack-trace
        ini_set('zend.exception_ignore_args', 0);

        ini_set('display_errors', 1);

        self::$old_error_level = error_reporting(self::$level);

        if (CarbonPHP::$test) {

            return self::$old_error_level;

        }

        /**
         * if you return true from here it will continue script execution from the point of the error..
         * this is not wanted. Die and Exit are equivalent in execution. I ran across a post once that
         * explained how die should signify a complete error with no resolution, while exit has resolution
         * returning 1 rather than 0 in both cases will signify an error occurred
         * @param array $errorForTemplate
         * @internal param TYPE_NAME $closure
         */


        /**
         * php.net/manual/en/function.set-error-handler.php
         *      return true from here it will continue script execution
         *      return false and PHP will use it's built in error handler
         *
         * @param int $errorLevel
         * @param string $errorString
         * @param string $errorFile
         * @param int $errorLine
         * @return bool
         * @link https://www.php.net/manual/en/function.set-error-handler.php
         * @link https://www.php.net/manual/en/function.set-exception-handler.phpd
         */
        $error_handler = static function (int $errorLevel, string $errorString, string $errorFile, int $errorLine) {

            static $errorsHandled = 0;

            if (0 === $errorsHandled) {

                ColorCode::colorCode("Note :: warnings will not be caught by a try catch block, they signal error and should corrected but typically may be 'recoverable'. Some warnings PHP, such as 'max file descriptors reached', are more critical and should be handled with care. For this reason it's important to keep logs of warnings and correct/suppress when necessary. For suppression see @link https://stackoverflow.com/questions/1241728/can-i-try-catch-a-warning", iColorCode::CYAN);

            }

            static $fatalError = false;

            $errorsHandled++;

            $browserOutput = [];

            // refer to link on this one
            /*if (!(error_reporting() & $errorLevel)) {
                // This error code is not included in error_reporting, so let it fall
                // through to the standard PHP error handler
                return false;
            }*/

            $browserOutput['PHP'] = PHP_VERSION . ' (' . PHP_OS . ')';

            switch ($errorLevel) {
                case E_ALL:
                    $browserOutput['FATAL ERROR'] ??= 'E_ALL';
                case E_ERROR:
                    $browserOutput['FATAL ERROR'] ??= 'E_ERROR';
                case E_RECOVERABLE_ERROR:
                    $browserOutput['FATAL ERROR'] ??= 'E_RECOVERABLE_ERROR';
                case E_PARSE:
                    $browserOutput['FATAL ERROR'] ??= 'E_PARSE';
                case E_STRICT:
                    $browserOutput['FATAL ERROR'] ??= 'E_STRICT';
                case E_DEPRECATED:
                    $browserOutput['FATAL ERROR'] ??= 'E_DEPRECATED';
                case E_COMPILE_ERROR:
                    $browserOutput['FATAL ERROR'] ??= 'E_COMPILE_ERROR';
                case E_USER_ERROR:
                    $browserOutput['FATAL ERROR'] ??= 'E_USER_ERROR';
                default:
                    $browserOutput['FATAL ERROR'] ??= "Unknown error type ($errorLevel) with message ($errorString)";

                    $fatalError = true;

                    $browserOutput["ERROR MESSAGE"] = $errorString;

                    break;

                case E_WARNING:
                    $browserOutput['RECOVERABLE WARNING'] ??= 'E_WARNING';
                case E_NOTICE:
                    $browserOutput['RECOVERABLE WARNING'] ??= 'E_NOTICE';
                case E_CORE_WARNING:
                    $browserOutput['RECOVERABLE WARNING'] ??= 'E_CORE_WARNING';
                case E_COMPILE_WARNING:
                    $browserOutput['RECOVERABLE WARNING'] ??= 'E_COMPILE_WARNING';
                case E_USER_WARNING:
                    $browserOutput['RECOVERABLE WARNING'] ??= 'E_USER_WARNING';
                case E_USER_NOTICE:
                    $browserOutput['RECOVERABLE WARNING'] ??= 'E_USER_NOTICE';
                case E_USER_DEPRECATED:
                    $browserOutput['RECOVERABLE WARNING'] ??= 'E_USER_DEPRECATED';

                    $browserOutput["WARNING MESSAGE"] = $errorString;

                    break;
            }

            $browserOutput['FILE'] = $errorFile;

            $browserOutput['LINE'] = (string)$errorLine;

            $warning = array_key_exists('RECOVERABLE WARNING', $browserOutput);

            $color = $warning ? iColorCode::YELLOW : iColorCode::RED;

            ColorCode::colorCode('The Global Error (set_error_handler) Handler has been invoked.', $color);

            ColorCode::colorCode("code: $errorLevel, message: $errorString, $errorFile:$errorLine", $color);

            self::generateLog(null, false === $fatalError, (string)$errorLevel, $browserOutput, $color);

            return $warning;  // todo this will continue execution for set_error_handler

        };

        /**
         * if you return true from here it will continue script execution
         *
         * @param Throwable $exception
         * @return bool
         */
        $exception_handler = static function (Throwable $exception) {

            ColorCode::colorCode('The Global Exception (set_exception_handler) Handler has been invoked.', iColorCode::MAGENTA);

            $browserOutput = ['Exception Handler' => 'CarbonPHP Generated This Report.'];

            self::generateLog($exception, false, null, $browserOutput, iColorCode::YELLOW);

            ColorCode::colorCode('Returning from $exception_handler.', iColorCode::BACKGROUND_RED);

            return false;   // php will exit after this

        };

        // the return hint on set_error_handler is incorrect as array may also be returned.
        // @link https://www.php.net/manual/en/function.set-error-handler.php
        self::$old_error_handler = set_error_handler($error_handler);

        self::$old_exception_handler = set_exception_handler($exception_handler);   // takes one argument

        return self::$old_error_level;

    }

    public static function stop(bool $ignoreRedundantStops = false): void
    {

        if (false === $ignoreRedundantStops && self::$old_error_level === null) {
            /** trigger_error is just a warning here
             * @link https://www.php.net/manual/en/language.exceptions.php
             * @link https://stackoverflow.com/questions/1095860/is-there-any-way-to-show-or-throw-a-php-warning
             **/
            trigger_error('Looks like you are trying to run ThrowableHandler::stop() before running start. This is not supported.', E_USER_WARNING);

            return;
        }

        error_reporting(self::$old_error_level);

        $error_handler = self::$old_error_handler;

        $exception_handler = self::$old_exception_handler;

        set_error_handler($error_handler);

        set_exception_handler($exception_handler);   // takes one argument

    }

    public static function jsonEncodeAndWrapForHTML($code): string
    {

        if (false === is_string($code)) {

            try {

                /** @noinspection JsonEncodingApiUsageInspection */
                $code = json_encode($code, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) ?: serialize($code);

            } catch (Throwable $e) {

                $code = print_r($code, true);

                if (false === $code) {

                    ColorCode::colorCode('The trace failed to be json_encoded, serialized, or printed with print_r().', iColorCode::RED);

                    ColorCode::colorCode($e->getMessage(), iColorCode::RED);

                    $code = '** PARSING FAILED **';

                }

            }

        }

        return "<pre>$code</pre>";

    }


    /** Generate a full error log consisting of a stack trace and arguments to each function call
     *
     *  The following functions point to this method by passing the arguments on via redirection.
     *  The required method signatures are different, so it is important that we do not type hint this function.
     *
     *  The options to make this signatures unique are compelling, but df essential.
     *
     *  set_error_handler
     *  set_exception_handler
     *
     * @param Throwable|array|null $e
     * @param bool $return
     * @param string|null $level
     * @param array $log_array
     * @param string $color
     * @return array
     * @internal param $argv
     * @noinspection ForgottenDebugOutputInspection
     * @noinspection JsonEncodingApiUsageInspection
     */
    public static function generateLog(Throwable $e = null, bool $return = false, string $level = null, array &$log_array = [], string $color = iColorCode::RED): array
    {

        $parseMessage = static function (mixed $log_array) {

            $message = json_encode($log_array, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_PARTIAL_OUTPUT_ON_ERROR);

            if (false === $message) {

                $log_copy = $log_array;

                ColorCode::colorCode('The designated \$cliOutputArray failed to json_encode. This may be due to a call stack which passes objects as parameters, a cicilic reffrence (recursion), an extremely large callstack for long running, or forever-running, programs. Should the output below be unhelpful you should you explore further using xDebug.',
                    iColorCode::YELLOW);

                $log_copy[self::DEBUG_BACKTRACE] = '*EXCLUDED FOR POSSIBLE RECURSION*';

                $message = json_encode($log_copy, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_PARTIAL_OUTPUT_ON_ERROR);

                if (false === $message) {

                    $log_array['JSON_ENCODE FAILURE'] = json_last_error_msg();

                    $message = print_r($log_array, true);

                }

            }

            return $message;

        };

        if (null !== $e) {

            ColorCode::colorCode("Generating pretty error message using C6 tools. Message ::", iColorCode::CYAN);

            ColorCode::colorCode("\t" . get_class($e), $color);

            ColorCode::colorCode("\t\t" . $e->getMessage(), $color);

        }

        if (null === $level) {

            $level = 'log';

        }

        if (!CarbonPHP::$test &&
            (CarbonPHP::$http || CarbonPHP::$https)) {

            // Attempt to remove any previous in-progress output buffers
            while (1 < ob_get_level()) {

                // this is ideal as ob_end_flush() would remove the back-to-browser buffer.
                // it also doesn't bother returning the buffer
                ob_end_clean();

            }

        }

        if ($e instanceof Throwable) {

            $class = get_class($e);

            [$traceCLI, $traceHTML] = self::generateCallTrace($e);

            $log_array = [
                    $class => $e->getMessage()
                ] + $log_array;

            $log_array['ERROR TYPE'] = 'A Public Alert Was Thrown!';

            $log_array['FILE'] = $e->getFile();

            $log_array['LINE'] = (string)$e->getLine();

            /** @noinspection SuspiciousAssignmentsInspection */
            $log_array['JUMP'] = $log_array['FILE'] . ':' . $log_array['LINE'];

            $log_array['CODE'] = (string)$e->getCode();

        } else {

            [$traceCLI, $traceHTML] = self::generateCallTrace();

        }

        $log_array['[C6] CARBONPHP'] = __FILE__ . ' ' . __METHOD__;

        $log_array['METHOD'] = $_SERVER['REQUEST_METHOD'] ?? (PHP_SAPI === 'cli' ? 'CLI' : 'UNKNOWN');

        $log_array['$_COOKIE'] = ($_COOKIE ?? []);

        $log_array['$_REQUEST'] = ($_REQUEST);

        $log_array['$_SERVER'] = ($_SERVER);

        if (false === CarbonPHP::$cli) {

            $log_array['URI'] = $_SERVER['REQUEST_URI'];

        }

        $log_array[self::TRACE] = $traceHTML;

        $json = $GLOBALS['json'] ??= [];

        $log_array[self::GLOBALS_JSON] = $json;

        if (array_key_exists('sql', $json) && is_array($json['sql']) && !empty($json['sql'])) {

            $lastRestStatement = $json['sql'][array_key_last($json['sql'])] ?? '';

            if ('' !== $lastRestStatement) {

                $log_array['LAST_REST_STATEMENT'] = $lastRestStatement;

            }

        }


        if (false === CarbonPHP::$cli) {

            // its so verbose with the TRACE above, we can afford to minimise the output here;
            // we loose nothing but immediate readability, which is fine as the TRACE is more useful
            // no data is lost by encoding early
            $log_array[self::DEBUG_BACKTRACE] = json_encode(debug_backtrace());

        } else {

            $log_array[self::DEBUG_BACKTRACE] = 'Omitted in CLI mode. The TRACE above should be more useful anyway. (' . __FILE__ . ')';

        }

        if (CarbonPHP::$setupComplete) {

            if (Database::$carbonDatabaseInitialized) {

                try {

                    $preparse = $status = Database::fetchAll('SHOW ENGINE INNODB STATUS');

                    $status = $status[0] ?? [];

                    $status = explode(PHP_EOL, $status['Status'] ?? '');

                    $log_array['INNODB_STATUS'] = empty($status) ? $preparse : $status;

                } catch (Throwable $e) {

                    $log_array['INNODB_STATUS'] = 'Unable to fetch! (SHOW ENGINE INNODB STATUS)';

                }

            } else {

                $log_array['INNODB_STATUS'] = 'Database::$carbonDatabaseInitialized was set to false! This was probably set in Database::newInstance. (SHOW ENGINE INNODB STATUS) will only log if already connected.';
            }

        }

        $codePreview = self::grabCodeSnippet();

        // todo - log invalid files?
        if ($codePreview === ''
            && ($log_array['FILE'] ?? false)
            && ($log_array['LINE'] ?? false)
            && is_numeric($log_array['LINE'])) {

            $codePreview = self::grabFileSnippet($log_array['FILE'], $log_array['LINE']);

        }

        $firstKey = array_key_first($log_array);

        $firstValue = $log_array[$firstKey];

        unset($log_array[$firstKey]);

        $log_array = [
            $firstKey => $firstValue,
            'THROWN NEAR' => "<pre><code>$codePreview</code></pre>",
            ...$log_array
        ];

        $html_error_log = self::generateBrowserReport($log_array, true);

        $log_array[self::TRACE] = $traceCLI;

        $log_array['THROWN NEAR'] = 'EXCLUDED IN CLI';

        if (self::$storeReport === true) {

            $log_file_general = 'logs/ThrowableHandlerReport/id_' . ($_SESSION['id'] ?? 'guest') . '_' . session_id() . '_' . microtime(true) . '_' . getmypid();

            $log_file_html = $log_file_general . '.html';

            $log_file_json = $log_file_general . '.json';

            $log_array[self::STORAGE_LOCATION_KEY] = "Will store report to file <a href=\"/$log_file_html\">("
                . CarbonPHP::$app_root . '/' . $log_file_html . ")</a> and <a href=\"/$log_file_json\">(" . CarbonPHP::$app_root . $log_file_json . ')';

            if (false === $e instanceof PDOException) {

                $log_array['[C6] STORAGE ISSUE'] = 'Errors which are instances of PDOException currently are not stored to database! This helps prevent recursive issues.';

            } else if (Database::$carbonDatabaseInitialized) {

                try {

                    $reports = Rest::getDynamicRestClass(Reports::class);

                    $postData = [
                        $reports::LOG_LEVEL => $level,
                        $reports::REPORT => $traceHTML,
                        $reports::CALL_TRACE => $html_error_log
                    ];

                    /** @noinspection PhpUndefinedMethodInspection */
                    if (false === $reports::post($postData)) {

                        error_log($message = 'Failed storing log in database. The restful Reports table returned false.');

                        $log_array['[C6] ISSUE'] = $message;

                        die(1);

                    }

                } catch (Throwable $e) {

                    error_log($message = 'Failed storing log in database. The restful Carbon_Reports table through and error :: ' . $e->getMessage());

                    $log_array['[C6] ISSUE'] = $message;

                }

            } else {

                error_log($message = 'An error occurred before the database use initialized. This likely means you have no database configurations, or a general configuration issue issues occurred :: ' . $e->getMessage());

                $log_array['[C6] ISSUE'] = $message;

                $log_array['[C6] STORAGE ISSUE'] = 'The database was not initialized when the error occurred. Storage to the database was not possible.';

            }

            Files::createDirectoryIfNotExist(dirname(CarbonPHP::$app_root . $log_file_html));

            Files::createDirectoryIfNotExist(dirname(CarbonPHP::$app_root . $log_file_json));

            if (false === file_put_contents(CarbonPHP::$app_root . $log_file_html, $html_error_log)
                || false === file_put_contents(CarbonPHP::$app_root . $log_file_json, $parseMessage($log_array))) {

                ColorCode::colorCode("Failed to store html log using file_put_contents. File :: ($log_file_html) or ($log_file_json)", iColorCode::RED);

                self::exitAndSendBasedOnRequested($log_array, $html_error_log);

            }

            $log_array[self::STORAGE_LOCATION_KEY] = "HTML report stored to file <a href=\"/$log_file_html\">("
                . CarbonPHP::$app_root . '/' . $log_file_html . ")</a> and <a href=\"/$log_file_json\">(" . CarbonPHP::$app_root . $log_file_json . ')';

        }

        $messageRepeat = $log_array["WARNING MESSAGE"] ?? $log_array['ERROR MESSAGE'] ?? false;

        if (false !== $messageRepeat) {

            $log_array['MESSAGE AGAIN'] = $messageRepeat;

        }


        /** @noinspection JsonEncodingApiUsageInspection */
        $message = $parseMessage($log_array);

        switch (self::$throwableReportDisplay) {


            /** @noinspection PhpMissingBreakStatementInspection */
            case ThrowableReportDisplay::CLI_MINIMAL:

                if (self::$storeReport && array_key_exists(self::STORAGE_LOCATION_KEY, $log_array)) {

                    ColorCode::colorCode("Stored report to file \n\tfile://"
                        . CarbonPHP::$app_root . $log_file_html . "\n\tfile://" . CarbonPHP::$app_root . $log_file_json, $color);

                    ColorCode::colorCode('file://' . $log_array['FILE'] . ':' . $log_array['LINE'], $color);

                    break;

                }

                ColorCode::colorCode(self::class . "::\$storeReport needs to be on for ThrowableReportDisplay::CLI_MINIMAL to take effect!", iColorCode::RED);

            case ThrowableReportDisplay::FULL_DEFAULT:

                ColorCode::colorCode($message, $color);

                break;


        }


        if (false === $return) {

            if (false === CarbonPHP::$cli) {    // we have alreay logged

                if (headers_sent()) {

                    if (true === self::$storeReport) {

                        if (false === self::shouldSendJson()) {

                            print <<<REDIRECT
                            <meta http-equiv="refresh" content="0; URL=/$log_file_html" />
                            <script>window.location.replace("/$log_file_html");</script>
                            REDIRECT;

                        }

                        exit(1);

                    }

                    ColorCode::colorCode('HEADERS ALREADY SENT! Reporting to the browser can potentially be made more readable if you choose'
                        . ' to store the reports (currently off). The CarbonPHP configuration will allow, on errors with the headers sent, to'
                        . ' intelligently redirect the users to the error message. This is opposed to loading a non-compliant HTML '
                        . ' page and hoping the browser displays readable content. Surprisingly the browser does do well at this, but'
                        . ' you end user experience could be better. @note storing logs cost memory, for more information visit CarbonPHP.com',
                        iColorCode::BACKGROUND_CYAN);

                }

                self::exitAndSendBasedOnRequested($log_array, $html_error_log);

            }

            self::closeStdoutStderrAndExit(1);

        }

        ColorCode::colorCode('Returning Error Information', iColorCode::CYAN);

        return [
            self::LOG_ARRAY => $log_array,
            self::HTML_ERROR_PAGE => $html_error_log,
            self::STORED_HTML_LOG_FILE_PATH => $log_file_html ?? 'N/A'
        ];

    }

    public static function generateLogAndExit(Throwable $e = null, string $level = null, array &$log_array = [], string $color = iColorCode::RED): never
    {

        self::generateLog($e, false, $level, $log_array, $color);

        exit(231);

    }


    /** A simplified back trace for quickly identifying route.
     * reverse array to make steps line up chronologically
     * @link http://php.net/manual/en/function.debug-backtrace.php
     * @param Throwable $e
     * @return string|array
     */
    protected static function generateCallTrace(Throwable $e = null): array
    {

        if (null === $e) {

            ColorCode::colorCode("Generating new stack trace with Throwable. This might not capture all information needed :/",
                iColorCode::YELLOW);

        }

        $_SERVER["CONTENT_TYPE"] ??= '';

        self::$methodName = self::$className = '';

        if (false === CarbonPHP::$cli) {

            ob_start(null, 0, PHP_OUTPUT_HANDLER_CLEANABLE
                | PHP_OUTPUT_HANDLER_FLUSHABLE | PHP_OUTPUT_HANDLER_REMOVABLE);     // start a new buffer for saving errors

        }

        if (null === $e) {

            $e = new \Exception();

        }

        $trace = $e->getTrace();

        $trace = array_reverse($trace);

        $trace[] = [
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'code' => $e->getCode(),
            'preview' => self::grabFileSnippet($e->getFile(), $e->getLine(), true),
        ];

        $traceWithKeys = [];

        foreach ($trace as $key => &$value) {

            if (array_key_exists('file', $value) && array_key_exists('line', $value)) {

                $value['jump'] = $value['file'] . ':' . $value['line'];

            }

            $traceWithKeys['CALL TRACE ' . $key] = $value;

        }

        return [$traceWithKeys, PHP_EOL . json_encode($traceWithKeys, JSON_THROW_ON_ERROR | JSON_PRETTY_PRINT) . PHP_EOL];
    }

    /**
     * @param array $message
     * @param int $code
     * @return string
     */
    protected static function errorTemplate(array $message, int $code = 200): string
    {

        $cleanErrorReport = '';

        $actual_message = array_key_first($message);

        if (CarbonPHP::$app_local || self::$printToScreen) {

            foreach ($message as $left => $right) {

                if (!is_string($left)) {

                    // this should never happen..
                    $left = json_encode($left, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) ?: serialize($left);

                }

                $blocks = $left === self::TRACE
                    || $left === self::GLOBALS_JSON
                    || $left === self::DEBUG_BACKTRACE
                    || $left === self::INNODB_STATUS;

                if ($blocks) {

                    $right = self::jsonEncodeAndWrapForHTML($right);

                }

                if (is_array($right)) {

                    $right = self::jsonEncodeAndWrapForHTML($right);

                }

                $cleanErrorReport .= $blocks ?
                    <<<DESCRIPTION
<p>> <span>$left</span>: <i>$right</i></p>

DESCRIPTION
                    :
                    <<<DESCRIPTION
<p>> <span>$left</span>: <b style="color: white">"</b><i>$right</i><b style="color: white">"</b></p>
DESCRIPTION;

            }

        } else {

            $cleanErrorReport = <<<PRODUCTION
                    <p>> <span>ERROR DESCRIPTION</span>: "<i>Something went wrong on our end. We will be investigating soon.</i>"</p>
                    <p>> <span>ERROR POSSIBLY CAUSED BY</span>: [<b>execute access forbidden, read access forbidden, write access forbidden, ssl required, ssl 128 required, ip address rejected, client certificate required, site access denied, too many users, invalid configuration, password change, mapper denied access, client certificate revoked, directory listing denied, client access licenses exceeded, client certificate is untrusted or invalid, client certificate has expired or is not yet valid, passport logon failed, source access denied, infinite depth is denied, too many requests from the same client ip</b>...]</p>
                    <p>> <span>SOME PAGES ON THIS SERVER THAT YOU DO HAVE PERMISSION TO ACCESS</span>: [<a href="/">Home Page</a>, <a href="/about">About Us</a>, <a href="/contact">Contact Us</a>, <a href="/Blog">Blog</a>...]</p>
                    PRODUCTION;

        }

        $statusText = self::statusText($code);

        $public_root = trim(CarbonPHP::$public_carbon_root, '/');

        if ('' !== $public_root) {

            $public_root = '/' . $public_root;

        }

        return (new \Mustache_Engine())->render(self::$errorTemplate, [
            'carbon_public_root' => $public_root,
            'public_root' => trim(CarbonPHP::$public_carbon_root ?? '', '/'),
            'code' => $code,
            'statusText' => $statusText,
            'actual_message' => $actual_message,
            'actual_message_body' => $message[$actual_message],
            'cleanErrorReport' => $cleanErrorReport,
            'json' => $GLOBALS['json'] ?? 'null',
            'json_string' => json_encode($GLOBALS['json'] ?? null, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES)
        ]);
    }

    public static function statusText(int $code = 0): ?string
    {
        // List of HTTP status codes.
        return [
            100 => 'Continue',
            101 => 'Switching Protocols',
            200 => 'OK',
            201 => 'Created',
            202 => 'Accepted',
            203 => 'Non-Authoritative Information',
            204 => 'No Content',
            205 => 'Reset Content',
            206 => 'Partial Content',
            300 => 'Multiple Choices',
            302 => 'Found',
            303 => 'See Other',
            304 => 'Not Modified',
            305 => 'Use Proxy',
            400 => 'Bad Request',
            401 => 'Unauthorized',
            402 => 'Payment Required',
            403 => 'Forbidden',
            404 => 'Not Found',
            405 => 'Method Not Allowed',
            406 => 'Not Acceptable',
            407 => 'Proxy Authentication Required',
            408 => 'Request Timeout',
            409 => 'Conflict',
            410 => 'Gone',
            411 => 'Length Required',
            412 => 'Precondition Failed',
            413 => 'Request Entity Too Large',
            414 => 'Request-URI Too Long',
            415 => 'Unsupported Media Type',
            416 => 'Requested Range Not Satisfiable',
            417 => 'Expectation Failed',
            500 => 'Internal Server Error',
            501 => 'Not Implemented',
            502 => 'Bad Gateway',
            503 => 'Service Unavailable',
            504 => 'Gateway Timeout',
            505 => 'HTTP Version Not Supported'
        ][$code] ?? null;
    }

    /**
     * @param int|string|mixed $exitCode
     */
    public static function closeStdoutStderrAndExit($exitCode = 0): never
    {
        if (defined('STDOUT')) {

            fclose(STDOUT);

        }

        if (defined('STDERR')) {

            fclose(STDERR);

        }

        ob_start();

        self::stop();

        error_reporting(0);

        exit($exitCode);
    }

}
