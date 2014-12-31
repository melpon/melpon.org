requirejs.config({
    baseUrl: '../static/publication/io-2012-slides/js',
});
require(['order!../../js/kabukiza-wandbox-lt', 'order!modernizr.custom.45394',
         'order!prettify/prettify', 'order!hammer', 'order!slide-controller',
         'order!slide-deck'], function(someModule) {
});
