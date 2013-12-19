
$(function(){
    var usercard = new EJS({url: '/tpl/usercard.ejs'})
    var currentCard = null;
    var showcard = function showcard(){
      if(currentCard){
        currentCard.hide();
      }
      var t=$(this), parent = t.parent(), card = parent.children('.uCard');
      if(card.size()>0){
        currentCard = card.show();
      }else{
        var id = parseInt(parent.attr('data-user_id'));
        if(isNaN(id))return;
        card = $('#uCard_'+id);
        if(card.size()>0){
          currentCard = card.prependTo(parent).show();
        }else{
          if(!t.hasClass('loading')){
            t.addClass('loading');
            $.getJSON('/users/'+id+'.js', function(data){
              parent.prepend(usercard.render(data));
              currentCard=$('#uCard_'+id)
              t.removeClass('loading')
              if(t.hasClass('nohover')){
                currentCard.hide();
                t.removeClass('nohover');
              }
            });
          }
        }
      }
    }
    var mouseout=function mouseout(){
      var e = $(this);
      if(e.hasClass('loading')){
        e.addClass('nohover')
      }
    }
    $('img.avatar').livequery('mouseenter', showcard).livequery('mouseleave', mouseout);
    $('.post .thumb').livequery('mouseenter', showcard).livequery('mouseleave', mouseout);
    $('.uCard').livequery('mouseleave', function(){$(this).hide();});
    $('.uCard .follow-link a').livequery('click', function(e){
      e.preventDefault();
      var el = $(this), href=el.attr('href');
      el.text('...').attr('href', '').click(function(e){e.preventDefault();})
      $.post(href, function(data){
        var f = href.split('/')
        if(data.following){
          f[3] = 'unfollow.js';
          el.text('取消关注').attr('href', f.join('/'))
        }else{
          f[3] = 'follow.js';
          el.text('关注').attr('href', f.join('/'));
        }
      },'json')
    })
});
