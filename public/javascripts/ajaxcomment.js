
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
    if(v == ''){
        return false;
    }

    $.post(f.action, fe.serialize(), function(data){
        e.val('发表评论').attr('disabled', false);
        fe.find(".comment_input").val('').height('50px');
        var u = $('#qiushi_comments_'+fe.attr('data-article_id')).children('ul');
        if(u.size()>0){u.append(data);}
        else{
          $('<div>'+data+'</div>').insertBefore(fe);
        }
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
          $('#qiushi_counts_'+id).after(data).toggleClass('qiushi_counts_afterclick');
          comments_el.show();
          l.html(xx).trigger('loaded');
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

$(function(){
    $('input.comment_submit').live('click', postComment);
    //$('.comment_input').live('click', clear_warning).live('mouseover', clear_warning);
    //$('a.comments').click(loadComments);
    var hash=window.location.hash;
    if(hash.indexOf('#c-') === 0){
        $(hash).click();
    }
});