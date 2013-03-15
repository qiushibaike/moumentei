(function($){$.setCookie=function(name,value,options){if(typeof name==='undefined'||typeof value==='undefined')
return false;var str=name+'='+encodeURIComponent(value);if(options.domain)str+='; domain='+options.domain;if(options.path)str+='; path='+options.path;if(options.duration){var date=new Date();date.setTime(date.getTime()+options.duration*24*60*60*1000);str+='; expires='+date.toGMTString();}
if(options.secure)str+='; secure';return document.cookie=str;};$.delCookie=function(name){return $.setCookie(name,'',{duration:-1});};$.readCookie=function(name){var value=document.cookie.match('(?:^|;)\\s*'+name.replace(/([-.*+?^${}()|[\]\/\\])/g,'\\$1')+'=([^;]*)');return(value)?decodeURIComponent(value[1]):null;};$.CooQueryVersion='v 2.0';})(jQuery);
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
// Check whether element is currently within the viewport:
$.extend($.expr[':'],{
    inView: function(a) {
        var st = (document.documentElement.scrollTop || document.body.scrollTop),
            ot = $(a).offset().top,
            wh = (window.innerHeight && window.innerHeight < $(window).height()) ? window.innerHeight : $(window).height();
        return ot > st && ($(a).height() + ot) < (st + wh);
    }
});

var l = window.location.href;

function showAnimation(containerId, actionValue){
    var obj = $('#'+containerId),
        pos = obj.offset(),
        ani = $('<div style="color:red;position:absolute;display:none;font-size:10px">'+(actionValue > 0 ? "+1" : "-1")+"</div>");
        ani.appendTo('body');
    pos.top += $(document).scrollTop();
    pos.left += $(document).scrollLeft();
    ani.offset(pos).css('display', 'block').animate({'font-size': '64px', opacity: 0, top: "-=10px", left: "-=40px"}, 250, 'linear', function(){ani.remove()});
}

function SelfXY(){
    var yScrolltop;
    var xScrollleft;
    if (self.pageYOffset || self.pageXOffset) {
        yScrolltop = self.pageYOffset;
        xScrollleft = self.pageXOffset;
    } else if (document.documentElement && document.documentElement.scrollTop || document.documentElement.scrollLeft ){     // Explorer 6 Strict
        yScrolltop = document.documentElement.scrollTop;
        xScrollleft = document.documentElement.scrollLeft;
    } else if (document.body) {// all other Explorers
        yScrolltop = document.body.scrollTop;
        xScrollleft = document.body.scrollLeft;
    }
    arrayPageScroll = new Array(xScrollleft + event.clientX ,yScrolltop + event.clientY)
    return arrayPageScroll;
}


/**
 *  速度标记
 *
 */

function SpeedTester(){
    this.displayControlId = "divSpeed";

    this.goodColor = "#33CC33";
    this.averageColor = "#3300FF";
    this.badColor = "#FF0033";

    this.goodMessage = "仅用{0}秒就载入了整个页面，您的网络真棒";
    this.averageMessage = "载入整个页面用了{0}秒，您的网络马马虎虎";
    this.badMessage = "居然用了{0}秒才把整个页面载入进来，实在是抱歉";
    this.goodSpeed = 10000;
    this.averageSpeed = 50000;
    this.badSpeed = 100000;

    this.beginTest = function()    {
        this.startTime = new Date();

        window.onload = function(){
            var displayControl =document.getElementById(SpeedTester.displayControlId);
            if(!displayControl)return;
            SpeedTester.endTime = new Date();

            var spentTime = SpeedTester.endTime - SpeedTester.startTime;

            if (spentTime <= SpeedTester.goodSpeed){
                displayControl.style.backgroundColor = SpeedTester.goodColor;
                displayControl.title = SpeedTester.goodMessage.replace("{0}", spentTime / 1000);
            }else if (spentTime <= SpeedTester.averageSpeed){
                displayControl.style.backgroundColor = SpeedTester.averageColor;
                displayControl.title = SpeedTester.averageMessage.replace ("{0}", spentTime / 1000);
            }else{
                displayControl.style.backgroundColor = SpeedTester.badColor;
                displayControl.title = SpeedTester.badMessage.replace("{0}", spentTime / 1000);
            }
        }
    }
}

SpeedTester = new SpeedTester();
SpeedTester.beginTest();

function addBookmark(title,url) {
    if (window.sidebar) {
        window.sidebar.addPanel(title, url,"");
    } else if( document.all ) {
        window.external.AddFavorite( url, title);
    } else if( window.opera && window.print ) {
        return true;
    }
    return false;
}

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
    if('jStore' in jQuery){$.jStore.CurrentEngine.set(id, true)}
    return false;
}

function votedown(id, link){
    var negscore = parseInt($('#neg-score-'+id).text());
    showAnimation('neg-score-'+id, -1);
    $('#neg-score-'+id).text(negscore - 1)
    $('#score'+id+' .voteicon').hide();
    $.get(link.href);
    $(link).hide();
    if('jStore' in jQuery){$.jStore.CurrentEngine.set(id, true)}
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
    var posscore = parseInt($('#pos-score-'+id).text()),
        negscore = parseInt($('#neg-score-'+id).text()),
        d = (v>0?'up':'dn');
    showAnimation(d+'-'+id, v);
    if(currentUser){
        $.get('/articles/'+id+'/'+d);
    }else{
        voteQueue.push(v>0?id:-id);
    }
    v>0 ? posscore++ : negscore--;
    hidevotelink(id, posscore, negscore);

}
var vote3=vote2;
function hidevotelink2(id, p, n){
    var posscore = p || parseInt($('#pos-score-'+id).text());
    var negscore = n || parseInt($('#neg-score-'+id).text());
//    console.debug(id);
    $('#score-'+id).html('<strong>' + posscore + '</strong> :)<span class="space" style="zoom:1">|</span><strong>' + negscore + '</strong> :(');
}

var COMMENT_WARNING=window.location.hostname.indexOf('qiushi')>0 ?
    '请不要发表与本内容无关的评论，您有了账号就是有身份的人了，我们可认识您。'
    :'请不要发表与本秘密无关的评论。所有回复都将进入审核系统，含有电话号码、邮件地址、QQ号码等联系方式的回复将会被删除。';
function clear_warning(e){
    var t = $(this);
    t.focus();
    if($.trim(t.val()) == COMMENT_WARNING){
        t.val('');
    }
    t.blur(function(){
        var t=$(this);
        if($.trim(t.val())==''){
            t.val(COMMENT_WARNING);
        }
    });
}

function postComment(){
    var e =$(this),f = this.form, fe = $(f);
    var v = $.trim(fe.find('.comment_input').val());
    if(v == '' || v == COMMENT_WARNING){
        return false;
    }

    $.post(f.action, fe.serialize(), function(data){
        e.val('发表评论').attr('disabled', false);
        fe.find(".comment_input").val('').height('50px');
        var u = $('#qiushi_comments_'+fe.attr('data-article_id')).children('ul');
        if(u.size()>0){u.append(data);}
        else{$(data).insertBefore(fe);}
    });
    this.value = ('正在发表');
    this.disabled = true;

    return false;
}
function article_comments_path(id){
  return '/articles/'+id+'/comments.html';
}
function loadComments(e){
  var l=$(this);
  var id = /\d+/.exec(l.attr('id'));
  if(!id) return;
  id=id[0];
  var comments_el = $('#qiushi_comments_'+id);
  if(comments_el.size() == 0){
      var xx = l.html();
      l.text('...');
      $.get(article_comments_path(id), null, function(data){
          if(comments_el.size() == 0 ){
              $('#qiushi_counts_'+id).after(data).toggleClass('qiushi_counts_afterclick');
              comments_el.show();
              l.html(xx);
              if(typeof decrypt == 'function'){l.ready(decrypt)}
              l.ready(floorLink);
          }
      });
  }else{
      comments_el.toggle();
      $('#qiushi_counts_'+id).toggleClass('qiushi_counts_afterclick');
  }
  window.location.hash = l.attr('id');
  l.blur();
  e.preventDefault();
}
function showall(id){
  $('.hide', '#qiushi_comments_'+id).toggle();
}

var currentUser;
function onlogin(){
    if(voteQueue.length > 0){
        $.get('/votes', {ids: voteQueue.join(' ')});
    }
}
function showLogin(){
  if($.browser.msie){
    document.styleSheets[0].addRule('.login', 'display:inline !important');
  }else{
    document.styleSheets[0].insertRule('.login{display:inline !important;}',0);
  }
  showLogout('none');
}
function showLogout(type){
  type = type || 'inherited';
  if($.browser.msie){
    document.styleSheets[0].addRule('.logout', 'display:'+type+' !important');
  }else{
    document.styleSheets[0].insertRule('.logout {display:'+type+' !important;}',0);
  }
}

function loadLoginCookie(){
    var user = $.readCookie('login');
    if(user){
        try{
          user = eval('('+user+')');
          loadLogin(user);
        }catch(e){

        }
    }
    return $.getJSON('/session.js?'+(new Date().getTime()), loadLogin);
}
function loadLogin(data){
  if(data && data.user){
    currentUser=data.user;
    $('.username').text(currentUser.login);
    if(data.unread_messages_count > 0)$('#unread_messages_count').text(data.unread_messages_count);
    if(data.unread_notifications_count && data.unread_notifications_count > 0){
      $('#unread_notifications_count').text(data.unread_notifications_count);
    }
    showLogin();
  }else{
    currentUser=null;
    showLogout();
  }
}
$(loadLoginCookie);

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
function gotofloor(id,fl){
  var comment=$('#comment-'+id),f=comment.siblings('.floor-'+fl);
  if(f.size() > 0){ $.scrollTo(f, 1000) }
}

function createFloorLink(id, fi){
  $('#fl-'+id+'-'+fi).click(function(e){
    var a = $(this).attr('id').split('-');
    gotofloor(parseInt(a[1]),parseInt(a[2]));
    e.preventDefault();
  }).bt({
    contentSelector: "$('#comment-'+"+id+").parents('ul').contents('.floor-'+"+fi+").html()",
    positions: 'top',
    width: 300,
    fill: '#F7F7F7',
    strokeStyle: '#B7B7B7',
    spikeLength: 10,
    spikeGirth: 10,
    padding: 8,
    cornerRadius: 0
  });
}

function floorLink(){
    $('.comment').each(function(i,e){
      e = $(e);
      var b = e.children('.body');
      var content = b.html(), id = parseInt(e.attr('id').replace('comment-',''));
      content=content.replace(/(\d+)(f|F|L|l|楼)/g, function(o,i){
        if($.browser.msie){
        setTimeout("createFloorLink("+id+", "+i+")", 200);
        }else{
        setTimeout(createFloorLink, 200, id, i);
        }
        return "<a href='#comment-"+id+"' id='fl-"+id+"-"+i+"'>"+o+"</a>";
      });

      b.html(content);
    });
}

$(floorLink);

function report(e){
  var el = $(e), url = '/articles/'+parseInt(el.attr('id'))+'/tickets/new';
   el.bt({
    trigger: 'click',
    ajaxPath: url,
    width: 180,
    fill: '#F7F7F7',
    strokeStyle: '#B7B7B7',
    spikeLength: 10,
    spikeGirth: 10,
    padding: 8,
    cornerRadius: 0
});
}

function comment_vote(id,s){
  var se = $('#comment-'+id+' .score');
  se.text(parseInt(se.text())+s);
  $('#comment-score-'+id+' a').css('visibility', 'hidden');
  $.post('/comments/'+id+(s > 0 ? '/up' : '/dn'));
  //return false;
}
$(function(){
    $('#user_login').change(function(){
           { $.get("/users/check_login",{user_login:$(this).val()},
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
           {  $('#insertemail').html("<h2>请输入正确的邮箱地址</h2>");
           }

       })})
    function isEmail(str){
       var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
       return reg.test(str);
}
