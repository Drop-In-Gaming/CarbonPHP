function CarbonJS(selector, address, options) {
    function sleep(milliseconds) {
        let start = new Date().getTime();
        for (let i = 0; i < 1e7; i++) {
            if ((new Date().getTime() - start) > milliseconds) {
                break;
            }
        }
    }

    //-- I need php
    $.fn.isset = (v)=>{
        return (v !== '' && v !== null && v !== undefined);
    };

    //-- Json, no beef -->
    function isJson(str) {
        try {
            return JSON.parse(str)
        } catch (e) {
            return false
        }
    }

    //-- Bootstrap Alert -->
    $.fn.bootstrapAlert = (message, level) => {
        if (!$.fn.isset(level)) {
            level = 'info';
        }
        let container,node = document.createElement("DIV"), text;
        text = level.charAt(0).toUpperCase() + level.slice(1);
        container = selector + " div#alert";

        if(!$(container).length){
           if(!$("#alert").length)
               return alert(level + ' : ' + message);
           container = "#alert";
        }


        node.innerHTML = '<div id="row"><div class="alert alert-' + level + ' alert-dismissible">'
            + '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>'
            + '<h4><i class="icon fa fa-' + (level === "danger" ? "ban" : (level === "success" ? "check" : level))
            + '"></i>' + text + '!</h4>' + message + '</div></div>';

        $(container).html(node.innerHTML + $(container).html());
    };

    // A better closest function
    $.fn.closest_descendant = (filter) => {
        let $found = $(),
            $currentSet = this; // Current place
        while ($currentSet.length) {
            $found = $currentSet.filter(filter);
            if ($found.length) break;  // At least one match: break loop
            // Get all children of the current set
            $currentSet = $currentSet.children();
        }
        return $found.first(); // Return first match of the collection
    };

    $.fn.runEvent = (ev) => {
        let event;
        if (document.createEvent) {
            event = document.createEvent("HTMLEvents");
            event.initEvent(ev, true, true)
        } else {
            event = document.createEventObject();
            event.eventType = ev
        }
        event.eventName = ev;
        document.createEvent ? document.dispatchEvent(event) :
            document.fireEvent("on" + event.eventType, event);
    };

    $(document).on('submit', 'form[data-hbs]', function (event) {   // TODO - test a billion times
        $(this).ajaxSubmit({
            url: $(this).attr('action'),
            type: 'post',
            dataType: 'json',               // Change the data type???? post process html of JS to mustache here?
            success: function (data) {
                console.log('Form Mustache');
                console.log(data);
                MustacheWidgets(data);
                return false;
            },
            error: function(data) {
                console.log(data);
                console.log(data.responseText);
                $(selector).html(data.responseText);
            },
        });
        event.preventDefault();
    });

    // PJAX Forum Request
    $(document).on('submit', 'form[data-pjax]', (event) => {        // TODO - remove this pos
        $(selector).innerHTML = '';
        console.log('form[data-pjax]');
        $.pjax.submit(event, selector)
    });

    // All links will be sent with ajax
    $(document).pjax('a', selector);

    //$(document).on('pjax:click', () => $(selector).hide());

    $(document).on('pjax:success', () => console.log("Successfully loaded " + window.location.href));

    $(document).on('pjax:timeout', (event) => event.preventDefault());

    $(document).on('pjax:error', (event) => console.log("Could not load " + window.location.href));

    $(document).on('pjax:complete', () => {
        // Set up Box Annotations
        $.fn.runEvent("Carbon");
        //$(selector).fadeIn('fast').removeClass('overlay');
        $(".box").boxWidget({
            animationSpeed: 500,
            collapseTrigger: '[data-widget="collapse"]',
            removeTrigger: '[data-widget="remove"]',
            collapseIcon: 'fa-minus',
            expandIcon: 'fa-plus',
            removeIcon: 'fa-times'
        });
        $('#my-box-widget').boxRefresh('load');
    });

    $(document).on('pjax:popstate', () => $.pjax.reload(selector)); // refresh our state always!!

    let defaultOnSocket = false, statsSocket;

    if ($.fn.isset(address)) {
        if ($.fn.isset(options))
            defaultOnSocket = options;
        statsSocket = new WebSocket(address);
    }

    $.fn.trySocket = function () {
        if (address === null || address === '' || statsSocket.readyState === 0)
            return 0;

        if (statsSocket.readyState === 1)
            return 1;

        let count = 0;
        console.log('Attempting Reconnect');
        do {
            if (statsSocket !== null && typeof statsSocket === 'object' && statsSocket.readyState === 1)
                break;            // help avoid race
            statsSocket = new WebSocket(address);
        } while (statsSocket.readyState === 3 && ++count <= 3);  // 6 seconds 3 attempts
        if (statsSocket.readyState === 3)
            console.log = "Could not reconnect to socket. Connection aborted.";
        return (statsSocket.readyState === 1);
    };

    $.fn.startApplication = (url) => {
        console.log('URI::' + url);
        if (defaultOnSocket && $.fn.trySocket) {           //defaultOnSocket &&
            console.log('Socket::' + url);
            statsSocket.send(JSON.stringify(url));
        } else $.get(url, (data) => MustacheWidgets(data)); // json
    };

    function MustacheWidgets(data, url) {
        if (data !== null) {
            let json = (typeof data === "string" ? isJson(data) : data);

            console.log('MustacheWidgets');
            console.log(json);

            if (json && json.hasOwnProperty('Mustache')) {
                if (!json.hasOwnProperty('Widget')) {
                    json.Widget = selector;
                }
                if (!json.hasOwnProperty('Alert')) {
                    $.fn.bootstrapAlert(json.Alert);
                }
                console.log('Valid Mustache $( ' + json.Widget + ' ).render( ' + json.Mustache + ', ... ); \n');
                $.get(json.Mustache, (template) => {

                    //console.log('HBS-Template::');                                  // log

                    //console.log(template);                                      // TODO - comment out

                    Mustache.parse(template);                                   // cache

                    $(json.Widget).html(Mustache.render(template, json));       // render json with mustache lib

                    if (json.hasOwnProperty('scroll')) {                        // use slim scroll to move to bottom of chats (lifo)
                        $(json.scroll).slimscroll({start: json.scrollTo});
                    }
                });
            } else {
                console.log("Trimmers :: ");                    // log ( string )
                console.log(data);                              // log ( object ) - seperating them will print nicely
            }
        } else {
            console.log('RECEIVED NOTHING ?? ' + data);            //
            if (typeof data === "object" && url !== '') {
                console.log('Re-attempting Connection');
                setTimeout(() => $.fn.startApplication(url), 2000); // wait 2 seconds
            }
        }
    }

    if (address !== '' && address !== undefined) {
        statsSocket.onmessage = (data) => {
            //console.log('Socket Update');
            (isJson(data.data) ? MustacheWidgets(JSON.parse(data.data)) : console.log(data.data));
        }
        statsSocket.onerror = () => console.log('Web Socket Error');
        statsSocket.onopen = () => {
            $.fn.runEvent("Carbon");
            console.log('Socket Started');
            statsSocket.onclose = () => {                 // prevent the race condition
                console.log('Closed Socket');
                $.fn.trySocket();
            };
        };
    } else {
        $.fn.runEvent("Carbon");
    }
}


