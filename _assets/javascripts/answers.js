//= require vendor/jquery-1.11.1
//= require vendor/bootstrap/transition
//= require vendor/bootstrap/collapse
//= require vendor/typeahead.js
//= require vendor/augment
//= require vendor/lunr

;
var AnswersApp = (function ($,lunr) {
  var index = lunr(function () {
    this.field('title', {boost: 10})
    this.field('body')
    this.ref('id')
  });

  var refCache = [];

  $.getJSON( "/search.json", function( data ) {
    $.each( data.answers, function( key, val ) {
      if(val) {
        index.add(val);
        refCache[val.id] = val.title;
      }
    }); 
  });

  var lunrSource = function(query, cb) {
    var rs = [];
    var matches = index.search(query);
    $.each( matches, function (key, val) {
      rs.push({value: refCache[val.ref], path: val.ref});
    });
    cb(rs);
  };

  return {
    bind : function () {
      $('.typeahead').typeahead({
        minLength: 2,
        highlight: true,
      },
      {
        source: lunrSource
      });
      $('.typeahead').bind('typeahead:selected', function(ev,obj,idx) {
        window.location = obj.path;
      }); 
    }
  }
})(jQuery,lunr);

$(document).ready(function () {
  AnswersApp.bind();
});
