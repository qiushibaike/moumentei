var showReport;
$(function(){
  var showers = {
      'comment':function(comment_id){
        var el = $('#comment-'+comment_id+' .report'), o = el.offset(), cmt=$('#comment-'+comment_id);
        o.top += el.height();
        o.left += el.width();
        $('#report-form').trigger('close');
        cmt.addClass('highlight');
        $('#report-form input[name=comment_id]').val(comment_id);
        $('#report-form').css('display', 'block').offset(o);
      },
      'article':0,
      'user':0
  }
  showReport = function(){
      
  }
  $('#report-form').bind('close', function(){
    $(this).css('display', 'none');
    $('.highlight').removeClass('highlight');
  });
  $('#report-form form').submit(function(){
    var cmt_id = this.comment_id.value, a = this.action = '/comments/'+ cmt_id + '/report',
        f = $(this);
    submit_button=$('input[type=submit]', this).attr('disabled', 'disabled');
    $.post(a, f.serialize(), function(){
      submit_button.attr('disabled', '');
      $('#report-form').trigger('close');
    });
    return false;
  });
  $('#close-form').click(function(){
    $('#report-form').trigger('close');
  });
});
