(function($){$.setCookie=function(name,value,options){if(typeof name==='undefined'||typeof value==='undefined')
return false;var str=name+'='+encodeURIComponent(value);if(options.domain)str+='; domain='+options.domain;if(options.path)str+='; path='+options.path;if(options.duration){var date=new Date();date.setTime(date.getTime()+options.duration*24*60*60*1000);str+='; expires='+date.toGMTString();}
if(options.secure)str+='; secure';return document.cookie=str;};$.delCookie=function(name){return $.setCookie(name,'',{duration:-1});};$.readCookie=function(name){var value=document.cookie.match('(?:^|;)\\s*'+name.replace(/([-.*+?^${}()|[\]\/\\])/g,'\\$1')+'=([^;]*)');return(value)?decodeURIComponent(value[1]):null;};$.CooQueryVersion='v 2.0';})(jQuery);
function shareToSina(id){
  var s=screen,d=document,e=encodeURIComponent,a=$('#article'+id),u=$('.permlink', '#qiushi_counts_'+id).attr('href');
  var f='http://v.t.sina.com.cn/share/share.php?',p=['url=',e(u),'&title=',e('帖子'+id),'&appkey=2924220432'].join('');
  var a=function(){
    if(!window.open(f+p,'mb',['toolbar=0,status=0,resizable=1,width=620,height=450,left=',(s.width-620)/2,',top=',(s.height-450)/2].join('')))u=f+p;
  };
  if(/Firefox/.test(navigator.userAgent)){setTimeout(a,0)}else{a()}
}
function showAnimation(containerId, actionValue){
    var obj = $('#'+containerId),
        pos = obj.offset(),
        ani = $('<div id="vote-ani" class="'+(actionValue > 0 ? "pos" : "neg")+'" style="font-size:10px;">'+(actionValue > 0 ? "+1" : "-1")+"</div>");
        ani.appendTo('body');
    pos.top += $(document).scrollTop();
    pos.left += $(document).scrollLeft();
    ani.offset(pos).css('display', 'block').animate({'font-size': '64px', opacity: 0, left: "-=40px"}, 250, 'linear', function(){ani.remove()});
}

new function($) {
  $.fn.setCursorPosition = function(pos) {
    if ($(this).get(0).setSelectionRange) {
      $(this).get(0).setSelectionRange(pos, pos);
    } else if ($(this).get(0).createTextRange) {
      var range = $(this).get(0).createTextRange();
      range.collapse(true);
      range.moveEnd('character', pos);
      range.moveStart('character', pos);
      range.select();
    }
  }
}(jQuery);

var l = window.location.href;
var currentUser;

function watch(id){
  $('#favorite-'+id).children('a').attr('href', '/articles/remove_favorite/'+id).html('取消围观').removeClass('star').addClass('stared');
}

function unwatch(id){
  $('#favorite-'+id).children('a').attr('href', '/articles/add_favorite/'+id).html('围观').removeClass('stared').addClass('star');
}

$(function(){
    $('.favorite-button').click(function(){
      if ( $(this).children('a').attr('href')!="/login" ){
        new $(this).load($(this).children('a').attr('href'));
        return false;}
    else
        return true;
    });
    $('input.numeric').keydown(function(e){
        var k = e.keyCode;
        if(((k>47)&&(k<58)) ||
            (k == 8) ||
            (k == 46)||
            (k == 13)||
            (k>=96 && k<=105)){
            //            event.returnValue = true;
            return true;
        } else {
            e.returnValue = false;
            return false;
        }
    });
});

function open_form(id){
    $('#quickform-' + id).show();
    $('#reply-'+id).hide();
}

function close_form(id){
    $('#quickform-' + id).hide();
    $('#reply-'+id).show();
}

function reply(id){
    var f = $('#quickform-' + id);
    $.ajax({
        type: "POST",
        url: f.attr('action'),
        data: f.serialize(),
        success: function(){
            $('#comment-'+id)
        }
    })
    close_form(id);
    return false;
}

function voteup(id, link){
    var posscore = parseInt($('#pos-score-'+id).text());
    showAnimation('pos-score-'+id, 1);
    $('#pos-score-'+id).text(posscore + 1);
    $('#score'+id+' .voteicon').hide();
    $.get(link.href);
    $(link).hide();
    try{
      if('jStore' in jQuery){$.jStore.CurrentEngine.set(id, true)}
    }catch(e){}
    
    return false;
}

function votedown(id, link){
    var negscore = parseInt($('#neg-score-'+id).text());
    showAnimation('neg-score-'+id, -1);
    $('#neg-score-'+id).text(negscore - 1)
    $('#score'+id+' .voteicon').hide();
    $.get(link.href);
    $(link).hide();
    try{
      if('jStore' in jQuery){$.jStore.CurrentEngine.set(id, true)}
    }catch(e){}
    return false;
}

function hidevotelink(id, p, n){
    var posscore,negscore;
    if(typeof p === 'undefined'){
        posscore = parseInt($('#pos-score-'+id).text());
    }else{
        posscore = p;
    }
    if(typeof n === 'undefined'){
        negscore = parseInt($('#neg-score-'+id).text());
    }else{
        negscore = n;
    }

//    console.debug(id);
    $('#score-'+id).html('<strong><span id="pos-score-'+id+'">' + posscore + '</span></strong>人支持<span class="space" style="zoom:1">|</span><strong><span id="neg-score-'+id+'">' + negscore + '</span></strong>囧');
}
var voteQueue=[];
function vote2(id, v){
    if(currentUser){
      var posscore = parseInt($('#pos-score-'+id).text()),
          negscore = parseInt($('#neg-score-'+id).text()),
          d = (v>0?'up':'dn');
      showAnimation(d+'-'+id, v);
      $.get('/articles/'+id+'/'+d);
      v>0 ? posscore++ : negscore--;
      hidevotelink(id, posscore, negscore);
    }else{
      //voteQueue.push(v>0?id:-id);
      showLoginForm();
      $(document).bind('after_logged_in', function(){
        vote2(id, v);
      })
    }    
}
function vote3(id, v){
  var posscore_el = $('#pos-score-'+id), negscore_el = $('#neg-score-'+id);
  var scorea = $('#score-'+id).find('a');
  if(scorea.hasClass('disabled')) return;
  var posscore = parseInt(posscore_el.text()),
      negscore = parseInt(negscore_el.text()),
      d = (v>0?'up':'dn');
  //showAnimation(d+'-'+id, v);
  $.post('/articles/'+id+'/'+d);
  if(v>0){
      posscore++;
      posscore_el.text(posscore);

  }else{
      negscore--;
      negscore_el.text(negscore);
  }
  scorea.addClass('disabled');
}

$(document).keypress(function(e){
  if(e.ctrlKey && e.which == 13 || e.which == 10) {
    var o=e.target;
    if(o.form){
        var f=$(o.form).find('input.comment_submit');
        postComment.call(f[0]);
    }
  }
});

function loadScores(){
    var ids=[];
    $('.article').each(function(i,e){
        var id = parseInt($(e).attr('id').replace('article', ''));
        if(!isNaN(id) && id > 0){
            ids.push(id);
        }
    })
    if(ids.length == 0)return;
    $.getJSON('/scores', {ids:ids.join(' ')}, function(data, status){
        $.each(data, function(id, value){
            var s = value.score;
            $('#pos-score-'+id).text(s.pos);
            $('#neg-score-'+id).text(s.neg);
            if(value.rated){
                hidevotelink(id,s.pos,s.neg);
            }
            if(typeof value.watched != 'undefined'){
              if(value.watched){watch(id);}else{unwatch(id);}
            }
            if(s.public_comments_count==0){
                $('#c-'+id).text('暂无评论');
            }else{
                $('#c-'+id).text(s.public_comments_count+'条评论');
            }
        });
    })
}
$(loadScores);

/*
$(function(){
$('.comment').live('mouseenter', function(){
  $('.comment-score a', this).attr('visibility', 'display');
}).live('mouseleave', function(){
  $('.comment-score a', this).attr('visibility', 'hidden');
})
})*/
function comment_vote(id,s){
  var se = $('#comment-'+id+' .score');
  se.text(parseInt(se.text())+s);
  $('#comment-score-'+id+' a').css('visibility', 'hidden');
  if('jStore' in jQuery){
    if(jQuery.jStore.CurrentEngine.get('c'+id)){return}
    jQuery.jStore.CurrentEngine.set('c'+id, true);
  }
  $.post('/comments/'+id+(s > 0 ? '/up' : '/dn'));
  //return false;
}
$(function(){
    $('#user_login').change(function(){
           {$.get("/users/check_login",{user_login:$(this).val()},
           function(text){$('#insertlogin').html("<h2>"+text+"</h2>");});
           }

       })})
 $(function(){
    $('#user_email').change(function(){
    var email=$('#user_email').val();
       if(isEmail(email)){$.get("/users/check_email",{user_email:$(this).val()},
           function(text){
             /*  if (text!="can_use"){ */
               $('#insertemail').html("<h2>"+text+"</h2>");
               
       });
         }
       else
           {$('#insertemail').html("<h2>请输入正确的邮箱地址</h2>");
           }

       })})
    function isEmail(str){
       var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
       return reg.test(str);
}
$(function(){
    $('#invitation_code').change(function(){
    var invitation_code=$('#invitation_code').val();
            $.get("/users/check_invitation_code",{invitation_code:$(this).val()},
           function(text){$('#insertinvitation_code').html("<h2>"+text+"</h2>");});
       })})
$(function(){
  $('.comment').live('mouseenter', function(){
    $(this).addClass('hover');
    if(currentUser){
      $(this).children('.reply').css('visibility','visible');
      $(this).children('.report').css('display','inline');
    }
  }).live('mouseleave', function(){
    $(this).removeClass('hover');
    $(this).children('.reply').css('visibility', 'hidden')
    $(this).children('.report').css('display','none');
  })
})
function replyComment(comment_id, article_id, floor){
  var form = $('form', '#qiushi_comments_'+article_id), c = $('#comment-'+comment_id);
  $('input[name=comment[parent_id]]',form).val(comment_id);
  
  var t = $('textarea', form),o = t.val();
  nv = '回复'+floor+'L:'+ o;
  t.val(nv);
  $.scrollTo(form, 1000);
  t.focus();
  t.setCursorPosition(nv.length);
}

/*$(function(){
  $(".article").each(function(){
    var e=$(this), l = $('.permlink', e.next());
    bShare.addEntry({
      title:'帖子'+l.text(),
      url:l.attr('href'),
      summary:e.text(),
      content:e.html()});
  });
});*/
function addBookmark(title,url) {  
if (window.sidebar) {   
window.sidebar.addPanel(title, url,"");   
} else if( document.all ) {  
window.external.AddFavorite( url, title);  
} else if( window.opera && window.print ) {  
return true;  
}  
}  

function eachScore(ids, cb){
    $.getJSON('/scores?'+ids.join('+'), function(data){
        $.each(data, cb);
    });
}
