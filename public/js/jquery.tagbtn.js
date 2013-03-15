(function($) {
    $.fn.tagbtn = function() {

        return this.each(function() {
            var self = this;
            var textElement = $(self);

            var tagsBox = $("dl[rel=tag-list] dd");

            $("span.tagbtn",tagsBox).click(function(){
                var self = this;
                var val = $(self).text().trim();
                var tagArray = textElement.val().trim().split(/\s|\;\,/)

                if($.inArray(val,tagArray) == -1){
                    tagArray.push(val);
                    textElement.val(tagArray.join(" "));
                }

                // $(self).addClass("unable").unbind("click");
            });
        });

    };
})(jQuery);