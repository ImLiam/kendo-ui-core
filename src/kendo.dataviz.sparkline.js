(function(f, define){
    define([ "./dataviz/sparkline/kendo-sparkline", "./dataviz/sparkline/sparkline" ], f);
})(function(){

var __meta__ = { // jshint ignore:line
    id: "dataviz.sparkline",
    name: "Sparkline",
    category: "dataviz",
    description: "Sparkline widgets.",
    depends: [ "dataviz.chart" ]
};

}, typeof define == 'function' && define.amd ? define : function(a1, a2, a3){ (a3 || a2)(); });
