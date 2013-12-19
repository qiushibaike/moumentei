// Check whether element is currently within the viewport:
$.extend($.expr[':'],{
    inView: function(a) {
        var st = (document.documentElement.scrollTop || document.body.scrollTop),
            ot = $(a).offset().top,
            wh = (window.innerHeight && window.innerHeight < $(window).height()) ? window.innerHeight : $(window).height();
        return ot > st && ($(a).height() + ot) < (st + wh);
    }
});

$(function(){
  if(!$.throttle){return}

  var currentArticle=$('.article:inView').get(0);
  var allArticle = $('.article');
  var scrollOpt={axis: 'y', offset:-10};
  $(document).scroll(function(e){
    currentArticle = $('.article:inView').get(0) || currentArticle;
  })
  $(document).bind('keyup', 'j', $.throttle(250, true, function(e){
    var n = e.target.tagName;
    if(n == 'TEXTAREA' || n == 'INPUT'){return}
    if(currentArticle){
      var i = allArticle.index(currentArticle);
      $.scrollTo(currentArticle = allArticle.get(i+1),scrollOpt );
    }else{
      $.scrollTo(currentArticle = allArticle.get(0),scrollOpt);
    }
  })).bind('keyup', 'k', $.throttle(250, true, function(e){
    var n = e.target.tagName;
    if(n == 'TEXTAREA' || n == 'INPUT'){return}
    if(currentArticle){
      var i = allArticle.index(currentArticle);
      $.scrollTo(currentArticle = allArticle.get(i-1),scrollOpt);
    }else{
      $.scrollTo(currentArticle = allArticle.get(0),scrollOpt);
    }
  }));
})