/*
 *
 * Copyright (c) 2006-2008 Sam Collett (http://www.texotela.co.uk)
 * Licensed under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * Version 2.0.2
 * Demo: http://www.texotela.co.uk/code/jquery/newsticker/
 *
 * $LastChangedDate$
 * $Rev$
 *
 */
 
(function($) {
/*
 * A basic news ticker.
 *
 * @name     newsticker (or newsTicker)
 * @param    delay      Delay (in milliseconds) between iterations. Default 4 seconds (4000ms)
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @example  $("#news").newsticker(); // or $("#news").newsTicker(5000);
 *
 */
$.fn.newsTicker = $.fn.newsticker = function(delay)
{
	delay = delay || 4000;
	initTicker = function(el)
	{
		$.newsticker.clear(el);
		el.items = $("li", el);
		// hide all items (except first one)
		el.items.hide().end();
		// current item
		el.currentitem = Math.floor(Math.random()*el.items.size());
		doTick(el);
		startTicker(el);
	};
	startTicker = function(el)
	{
		el.tickfn = setInterval(function() { doTick(el) }, delay)
	};
	doTick = function(el)
	{
		// don't run if paused
		if(el.pause) return;
		// pause until animation has finished
		$.newsticker.pause(el);
		// hide current item
		$(el.items[el.currentitem]).fadeOut("slow",
			function()
			{
				$(this).hide();
				// move to next item and show
				el.currentitem = ++el.currentitem % (el.items.size());
				$(el.items[el.currentitem]).fadeIn("slow",
					function()
					{
						$.newsticker.resume(el);
					}
				);
			}
		);
	};
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase()!= "ul") return;
			initTicker(this);
		}
	)
	.addClass("newsticker")
	.hover(
		function()
		{
			// pause if hovered over
			$.newsticker.pause(this);
		},
		function()
		{
			// resume when not hovered over
			$.newsticker.resume(this);
		}
	);
	return this;
};


$.newsticker = $.newsTicker =
{
	pause: function(el)
	{
		(el.jquery ? el[0] : el).pause = true;
	},
	resume: function(el)
	{
		(el.jquery ? el[0] : el).pause = false;
	},
	clear: function(el)
	{
		el = (el.jquery ? el[0] : el);
		clearInterval(el.tickfn);
		el.tickfn = null;
		el.items = null;
		el.currentItem = null;
	}
}

})(jQuery);
