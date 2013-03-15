/**
 *
 */
function select_item(sel) {
    $("input:checkbox").each(function(){
      this.checked = sel(this.checked);
    })
}

function select_all(){select_item(function(){return true});}
function select_none(){select_item(function(){return false});}
function select_reverse(){select_item(function(i){return !i});}

function set_status(id, status){
    $('#status').load('/admin/set_status/' + id + '?status=' + status)
}


function load_comments(){
    var entry = $(this).parents('.entry');
    var id = entry.data('article_id');
    $.get('/admin/articles/'+id+'/comments').done(function(data){
        entry.append(data);
    })
    return false;
}

$(function(){
   $(".status-edit a").live('click', function(){
       var self = $(this);
       $.post(this.href, function(){
         self.parents('.entry').remove();
       });
       return false;
   })
   $('.comments-toggle').live('click', load_comments);
    $(".report-edit a").click(function(){
       var self = $(this);
       $.get(this.href, function(){
         self.parents('.entry').remove();
       });
       return false;
   })
   $('.comment-manage a').live('click', function(){
       var self = $(this);
       $.post(this.href, function(){
            self.parents('.comment').remove();
       });
       return false;
   });
   
   $('.entry a.close').live('click', function(){
       $(this).prev('.list').remove();
       $(this).remove();
       return false;
   })
   
   $(".track").click(function(){
     $.get(this.href,function(text){
         alert(text)
       $(this).parent().find("#trackinfo").html(text);
   });
       return false;
   });
});

function opendialog(url){
    $('#dialog').dialog('open');
    $('#dialog').load(url);
}

function deleteelse(form){
    if(form.delete_else.checked){
        form.delete_else.value = '';
        $("input.entry-id").each(function(){
            if(!this.checked){
                form.delete_else.value += this.value + ',';
            }
        });
        //console.debug(form.delete_else.value);
    }
    return true;
}
