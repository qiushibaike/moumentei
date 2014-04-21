/* after logged in, the document will receive 'after_logged_in' event */
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
function showLoginForm(){
  $('#login-form').lightbox_me({
  centered: true,
  onLoad: function() {
      $('#login').focus()
      }
  });
}
$(function(){
  $('.need-login').click(function(e){
    e.preventDefault(); 
    showLoginForm();
  });
  $('#login-form input[type=submit]').click(function(e){
    e.preventDefault();
    this.disabled=true;
    this.value='正在登录...';
    $(this.form).submit();
    return false
  });
  $('#login-form form').submit(function(e){
    e.preventDefault();
    var form = $(this);
    $.post('/session.js', form.serialize(), function(data){
      $('input[type=submit]', form).attr('disabled', '').val('登录');

      if('error' in data){
        form.children('p.notice').text(data['error']);
      }else{
        if($.browser.msie){
          document.styleSheets[0].removeRule('.logout');
        }else{
          if(document.styleSheets[0].cssRules[0].selectorText == '.logout'){
            document.styleSheets[0].deleteRule(0);
          }
        }
        loadLogin(data);
        $('#login-form').trigger('close');
        $(document).trigger('after_logged_in');
      }
    }, 'json')
    return false;
  })    
});
