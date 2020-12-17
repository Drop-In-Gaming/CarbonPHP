<?php

namespace {                                     // This runs the following code in the global scope
    use CarbonPHP\CarbonPHP;
    use CarbonPHP\Error\PublicAlert;
    use CarbonPHP\Programs\ColorCode;
    use CarbonPHP\View;

    //  Displays alerts nicely
    //  Seamlessly include the DOM

    /**
     * @param $message
     * @param $title
     * @param string $type
     * @param null $icon
     * @param int $status
     * @param bool $intercept
     * @param bool $stack
     */
    function JsonAlert($message, $title = 'danger', $type = 'danger', $icon = null, $status = 500, $intercept = true, $stack = true)
    {
        PublicAlert::JsonAlert($message, $title, $type, $icon, $status, $intercept, $stack);
    }

    /** Start application will start a bootstrap file passed to it. It will
     * store that instance in a static variable and reuse it for the proccess life.
     *
     * @param $reset
     * @return null|bool - if this is called recursively we want to make sure were not
     * returning true to a controller function, thus causing the model to run when unneeded.
     * So yes this is a self-stupid check..............
     * @link
     *
     */
    function startApplication($reset = ''): ?bool
    {
        return CarbonPHP::startApplication($reset);
    }


    /** This extends the PHP's built-in highlight function to highlight
     *  other file types. Currently java and html are custom colored.
     *  All languages should, to some degree, benefit from this.
     * @link http://php.net/manual/en/function.highlight-string.php
     * @param $argv - if a filepath is given load it from memory,
     *  otherwise highlight the string provided as code
     *
     * adding the following to your css will be essential
     *
     *
     * pre {
     * background-color:rgba(255,255,255,0.9);
     * max-height: 30%;
     * overflow:scroll;
     * margin:0 0 1em;
     * padding:.5em 1em;
     * }
     * ::-webkit-scrollbar {
     * -webkit-appearance: none;
     * width: 10px;
     * }
     *
     * ::-webkit-scrollbar-thumb {
     * border-radius: 5px;
     * background-color: rgba(230,32,45,0.5);
     * -webkit-box-shadow: 0 0 1px rgba(255,255,255,.5);
     * }
     *
     * which implies you wrap this function in pre. *not required atm* aka done 4 u
     *
     * @param bool $fileExt
     * @return string -- the text highlighted and converted to html
     */
    function highlight($argv, $fileExt = false): string
    {
        if ($fileExt === 'java') {
            ini_set('highlight.comment', '#008000');
            ini_set('highlight.default', '#000000');
            ini_set('highlight.html', '#808080');
            ini_set('highlight.keyword', '#0000BB; font-weight: bold');
            ini_set('highlight.string', '#DD0000');
        } else if ($fileExt === 'html') {
            ini_set('highlight.comment', 'orange');
            ini_set('highlight.default', 'green');
            ini_set('highlight.html', 'blue');
            ini_set('highlight.keyword', 'black');
            ini_set('highlight.string', '#0000FF');
        }

        if (file_exists($argv)) {
            $text = file_get_contents($argv);

            $lines = implode('<br />', range(1, count(file($argv))));

            $fileExt = $fileExt ?: pathinfo($argv, PATHINFO_EXTENSION);

            if ($fileExt !== 'php') {
                $text = ' <?php ' . $text;
            }
        } else {
            $text = ' <?php ' . $argv;

            $lines = implode('<br />', range(1, count(explode(PHP_EOL, $text))));

        }

        $text = highlight_string($text, true);  // highlight_string() requires opening PHP tag or otherwise it will not colorize the text

        $text = substr_replace($text, '', 0, 6);    // this removes the <code>

        $text = preg_replace('#^<span style="[\w\s\#">;:]*#', '', $text, 1);  // remove prefix

        $text = (($pos = strpos($text, $needle = '&lt;?php')) ?
            substr_replace($text, '', $pos, strlen($needle)) :
            $text);

        $text = (($pos = strrpos($text, $needle = '</span>')) ?
            substr_replace($text, '', $pos, strlen($needle)) :
            $text);

        $text = (($pos = strrpos($text, $needle = '</code>')) ?
            substr_replace($text, '', $pos, strlen($needle)) :
            $text);

        $text = '<span style="overflow-x: scroll">' . $text . '</span>';

        return "<table style='width: 100%'><tr><td class=\"num\">\n$lines\n</td><td>\n$text\n</td></tr></table>";

    }


    /** Ports the javascript alert function in php.
     * @param string $string
     */
    function alert($string = 'Stay woke')
    {
        static $count = 0;
        ++$count;
        print "<script>alert('(#$count)  $string')</script>\n";
    }

    /** Prots the javascript console.log() function
     * @link http://php.net/manual/en/debugger.php
     * @param string $data data to be sent to the browsers console
     */
    function console_log($data)
    {
        print '<script>console.log(\'' . json_encode($data) . '\')</script>' . PHP_EOL;
    }

    /** Output all parameters given neatly to the screen and continue execution.
     * @param array ...$argv variable length parameters stored as array
     */
    function dump(...$argv)
    {
        echo '<pre>';
        var_dump(\count($argv) === 1 ? array_shift($argv) : $argv);
        echo '</pre>';
    }

    /** This is dump()'s big brother, a better dump per say.
     * By default, this outputs the value passed in and exits our execution.
     * This is convent when dealing with requests that would otherwise refresh the session.
     *
     * @param mixed $mixed the variable to output.
     * You can output multiple variables by wrapping them in an array
     *       [$var, $var2, $anotherVar]
     *
     * @param bool $fullReport this outputs a backtrace and zvalues
     * @param bool $die -
     * @throws PublicAlert
     * @link http://php.net/manual/en/function.debug-zval-dump.php
     *
     * @link http://php.net/manual/en/function.debug-backtrace.php
     *
     * From personal experience you should not worry about Z-values, as it is almost
     * never ever the issue. I'm 99.9% sure of this, but if you don't trust me you
     * should read this full manual page
     * @noinspection ForgottenDebugOutputInspection
     * @noinspection PhpExpressionResultUnusedInspection
     */
    function sortDump($mixed, bool $fullReport = false, bool $die = true) : void
    {
        // Notify that sort dump was executed
        CarbonPHP::$cli or alert(__FUNCTION__);

        $backtrace = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 2);

        // Generate Report -- keep in mind were in a buffer here
        $output = static function (bool $cli) use ($mixed, $fullReport, $backtrace) : string {
            ob_start();
            print $cli ? PHP_EOL . PHP_EOL : '<br>';
            print $cli ? 'SortDump Called With (debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 2)) From' : '################### SortDump Called With (debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 2)) From ################';
            print $cli ? PHP_EOL . PHP_EOL : '<br><pre>';
            var_dump($backtrace ?? $backtrace[0]);
            print $cli ? PHP_EOL . PHP_EOL : '<br></pre>';
            print '####################### VAR DUMP ########################';
            print $cli ? PHP_EOL . PHP_EOL : '<br><pre>';
            var_dump($mixed);
            print $cli ? PHP_EOL : '<br>';
            print '#########################################################';
            if ($fullReport) {
                print '####################### MIXED DUMP ########################';
                $mixed = (\is_array($mixed) && \count($mixed) === 1 ? array_pop($mixed) : $mixed);
                print $cli ? PHP_EOL . PHP_EOL : '<br><pre>';
                debug_zval_dump($mixed ?: $GLOBALS);
                print $cli ? PHP_EOL . PHP_EOL : '</pre><br><br>';
                echo "\n####################### BACK TRACE ########################\n\n<br><pre>";
                print $cli ? PHP_EOL . PHP_EOL : '<br><pre>';
                var_dump(debug_backtrace());
                print $cli ? PHP_EOL : '</pre>';
            }
            return ob_get_clean();
        };

        // TODO - re-create a store to file configuration option
        #$file = REPORTS . 'Dumped/Sort_' . time() . '.log';
        #Files::storeContent($file, $report);

        if (CarbonPHP::$cli) {
            $report = $output(true);
            ColorCode::colorCode($report . PHP_EOL, 'red');
        } else if (!$die && CarbonPHP::$ajax) {
            View::$bufferedContent = base64_encode($report);
            exit($report);
        } else {
            print $report = $output(false);
            ColorCode::colorCode($output(true) . PHP_EOL, 'red');
        }

        if ($die) {
            exit(1);
        }
    }

    /**
     * Will typically be one more than expected as the reference
     * to this function will add one to the total
     * @link https://www.php.net/manual/en/function.debug-zval-dump.php
     * @param $mixed
     * @noinspection PhpExpressionResultUnusedInspection
     * @noinspection ForgottenDebugOutputInspection
     */
    function zValue($mixed)
    {
        print CarbonPHP::$cli ? PHP_EOL . PHP_EOL : '<br><pre>';
        debug_zval_dump($mixed);
        print CarbonPHP::$cli ? PHP_EOL . PHP_EOL : '</pre><br><br>';
        exit(1);
    }


    /**
     * This is array_merge_recursive but add
     * @return array Merged array
     * @link https://wordpress-seo.wp-a2z.org/oik_api/wpseo_metaarray_merge_recursive_distinct/
     */
    function array_merge_recursive_distinct()
    {
        $arrays = func_get_args();
        if (count($arrays) < 2) {
            if ($arrays === []) {
                return [];
            }
            return $arrays[0];
        }

        $merged = array_shift($arrays);

        foreach ($arrays as $array) {
            foreach ($array as $key => $value) {
                if (is_array($value) && (isset($merged[$key]) && is_array($merged[$key]))) {
                    $merged[$key] = array_merge_recursive_distinct($merged[$key], $value);
                } else {
                    $merged[$key] = $value;
                }
            }
        }
        return $merged;
    }

}