$(function(){
    $.ajaxPrefilter(function(options, originalOption, xhr){
        var token = $('meta[name="csrf-token"]').attr('content');
        if (token) xhr.setRequestHeader('X-CSRF-Token', token);        
    });
})