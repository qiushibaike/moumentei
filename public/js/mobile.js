$(function(){
  window.scrollTo(0, 1)
})

$(document).ready(function(){
  //console.debug('document ready')
  $('#articles_show').live('pageinit', function(){
    $('form#new_post').submit(function(){
      var f = $(this);
      /*
      $.mobile.changePage(f.attr('action'), {
        type: 'post',
        data: f.serialize(),
        reverse: true,
        changeHash: false,
        reloadPage: true
      })*/
      $.mobile.showPageLoadingMsg();
      $.post(f.attr('action'), f.serialize(), function(data){
        $('ul.comments').append(data).listview('refresh');
        $('#comments_new').dialog('close');
        $('textarea', f).val('');
        $.mobile.hidePageLoadingMsg();
      })
      return false;
    })
  })
  $('#articles_show').trigger('pageinit');
  $('#groups_index').live('pageinit', function(){
    $('li.group select').bind('change', function(){
      var el = $(this), v = el.val();
      if(v == 'yes'){
        $.get('/groups/'+el.data('group')+'/join.json');
      } else {
        $.get('/groups/'+el.data('group')+'/quit.json');
      }
    });
  }).trigger('pageinit');

})
