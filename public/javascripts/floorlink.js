
$(function(){
  var gotofloor=function (id,fl){
    var comment=$('#comment-'+id),f=comment.siblings('.floor-'+fl);
    if(f.size() > 0){$.scrollTo(f, 1000)}
  }

  var createFloorLink=function (id, fi){
    $('#fl-'+id+'-'+fi).click(function(e){
      var a = $(this).attr('id').split('-');
      gotofloor(parseInt(a[1]),parseInt(a[2]));
      e.preventDefault();    
    }).poshytip({
      className: 'tip-yellowsimple',
//      alignTo: 'target',
    	alignX: 'center',      
      content: function(){
        return($('#comment-'+id).parents('ul').contents('.floor-'+fi).html());
      }
    })
  }

  var floorLink=function(){
    var c;
    
    if(!this || this==window){
      c = $('.comment')
    }else{
      var id = this.id.replace('c-', '');
      c = $('.comment', '#qiushi_comments_'+id);      
    }
    c.each(function(i,e){
      e = $(e);
      var b = e.children('.body');
      var content = b.html(), id = parseInt(e.attr('id').replace('comment-',''));

      content=content.replace(/(\d+)(f|F|L|l|楼)/g, function(o,i){
        if($.browser.msie){
          setTimeout(function(){
            createFloorLink(id, i);
          }, 200);
        }else{
          setTimeout(createFloorLink, 200, id, i);
        }
        return "<a href='#comment-"+id+"' id='fl-"+id+"-"+i+"'>"+o+"</a>";
      });
      b.html(content);
    });
  }
  setTimeout(floorLink,100);
  $('.comments').one('loaded', floorLink);
});
