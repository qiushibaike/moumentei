/**
 * Fancy script sets up the page and runs the code in the div.js elements
 */
$(function(){
  $('div.example').each(function() {
    var target = $('.target, .alt-target', this);
	  var htmlSource = $('<div />').append(target.clone()).html();
	  htmlSource = $('<div class="html-source">' + escapeHTMLEncode(htmlSource) + '</div>');
	  var html = $('<div class="html-link"><a href="#">html</a></div>').click(function(){
	    if ($.browser.msie) {
	      // ugh!!! effing IE
	      $(this).parent().find('.html-source').toggle();
	    }
	    else {
	      $(this).parent().find('.html-source').slideToggle();
	    }
			return false;
		});
		var jsLink = $('<div class="html-link"><a href="#">javascript</a></div>').click(function(){
		  if ($.browser.msie) {
		    $(this).parent().find('.js').toggle();
		  }
		  else {
		    $(this).parent().find('.js').slideToggle();
		  }
			return false;
		});
		
		var cssSource = $('style', this);
		if (cssSource.length) {
		  cssSource = $('<div class="css-source">' + cssSource.html() + '</div>');
			var css = $('<div class="css-link"><a href="#">css</a></div>').click(function(){
			  if ($.browser.msie) {
					$(this).parent().find('.css-source').toggle();
			  }
			  else {
			    $(this).parent().find('.css-source').slideToggle();
			  }
				return false;
			});
		}
		
		var jsSource = $('.js', this);
		$(jsSource).before(html);
		$(jsSource).before(htmlSource);
		textareaWrap(htmlSource);
		$('textarea', htmlSource).data('target', target[0]).change(function(){
		  var newTarg = $($(this).val()).get(0);
		  $($(this).data('target')).replaceWith(newTarg);
		  $(this).data('target', newTarg);
		});
		htmlSource.hide();
		
		if (typeof css != 'undefined') {
		  $(jsSource).before(css);
			$(jsSource).before(cssSource);
			textareaWrap(cssSource);
			cssSource.hide();
		}
		
		$(jsSource).before(jsLink);
		//eval the source!
		eval(jsSource.html());
		textareaWrap(jsSource, true);
		$('textarea', jsSource).change(function(){
		  eval($(this).val());
		});
		jsSource.hide();
	});
	
	// add BeautyTip to js and html-source textareas
	$('div.js textarea, div.html-source textarea').bt('This is live code. Feel free to edit and try out new options. Click (or tab) out of the textarea to see the results of your edits. If things go awry, reload the page.', {positions: 'right', trigger: ['focus', 'blur'], overlap: 8, width: 150, cssStyles: {fontSize: '11px'}});
});

function textareaWrap(obj, escape) {
  var html = $(obj).html();
  if (escape) {
    html = escapeHTMLEncode(html);
  }
	$(obj).empty().append($('<textarea />').append(html));
	var $textarea = $('textarea', obj);
	$textarea.width('100%');
	var scrollHeight = $textarea.get(0).scrollHeight || 50;
	$('textarea', obj).css({height: scrollHeight});
}

function escapeHTMLEncode(str) {
	var div = document.createElement('div');
	var text = document.createTextNode(str);
	div.appendChild(text);
	return div.innerHTML;
 }
