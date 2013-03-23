function postComment(){
    var e =$(this),f = this.form, fe = $(f), textarea = fe.find('textarea');
    var v = $.trim(textarea.val());
    if(v == ''){
        return false;
    }

    $.post(f.action, fe.serialize(), function(data){
        e.val('发表评论').prop('disabled', false);
        var ol = fe.parents('.comments-wrap').find('ol');
        textarea.val('').height('50px');
        ol.append(data);
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
  var article = $(this).parents('.article');
  if(!id) return;
  id=id[0];

  var comments_el = $('#article_comments_'+id);
  if(comments_el.size() == 0){
      var xx = l.html();
      l.text('...');
      $.get(article_comments_path(id)).done(function(data){
          //;
          article.append(data);
          comments_el.show();
          l.html(xx).trigger('loaded').addClass('active');
      });
  }else{
      comments_el.toggle();
      l.toggleClass('active');
  }
  window.location.hash = l.attr('id');
  l.blur();
  e.preventDefault();
}

function showall(id){
  $('.hide', '#qiushi_comments_'+id).toggle();
}

$(function(){
    $('.respond form input[type=submit]').live('click', postComment);
    $('a.comments').live('click', loadComments);
    var hash=window.location.hash;
    if(hash.indexOf('#c-') === 0){
        $(hash).click();
    }
});