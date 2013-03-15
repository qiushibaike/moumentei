acl purge {
"74.117.62.162"; 
"173.212.227.178";
"64.120.245.144";
"localhost";
}

#director www round-robin {
#	{ .backend = { .host = "74.117.62.162"; .port = "8080";} }
#	{ .backend = { .host = "173.212.227.178"; .port = "8080"; } }
#  { .backend = { .host = "64.120.245.144"; .port = "8080"; } }
#}
backend nginx {
       .host = "localhost";
       .port = "8080";
}

# vcl_recv is called whenever a request is received 
sub vcl_recv {
     # Serve objects up to 2 minutes past their expiry if the backend
     # is slow to respond.
     set req.grace = 120s;

     if (req.url ~ "^/(images|stylesheets|javascripts|system)") {
        unset req.http.cookie;
     } 
     if (req.url ~ "\.(png|gif|jpg|swf|css)$") {
        unset req.http.cookie;
     }    

        # This uses the ACL action called "purge". Basically if a request to
        # PURGE the cache comes from anywhere other than localhost, ignore it.
        if (req.request == "PURGE") 
            {if (!client.ip ~ purge)
                {error 405 "Not allowed.";}
            return(lookup);}
  return(lookup);
}

# Called if the cache has a copy of the page.
sub vcl_hit {
        if (req.request == "PURGE") 
            {purge_url(req.url);
            error 200 "Purged";}
 
        if (!obj.cacheable)
           {return(pass);}
}
 
# Called if the cache does not have a copy of the page.
sub vcl_miss {
        if (req.request == "PURGE") 
           {error 200 "Not in cache";}
}

# Called after a document has been successfully retrieved from the backend.
sub vcl_fetch {
if (req.url ~ "^/(images|javascripts|stylesheets|system)") {
   unset beresp.http.set-cookie;
}
if (req.url ~ "\.(png|gif|jpg|swf|css)$") {
    unset beresp.http.set-cookie;
}
if (!beresp.cacheable) {
  return (pass);
}
if (beresp.http.Set-Cookie) {
   return (pass);
}   
return (deliver);
}

### vcl_hash creates the key for varnish under which the object is stored. It is
### possible to store the same url under 2 different keys, by making vcl_hash
### create a different hash.
sub vcl_hash {

    ### these 2 entries are the default ones used for vcl. Below we add our own.
    set req.hash += req.url;
    set req.hash += req.http.host;
    if (req.http.Cookie) {
      set req.hash += req.http.Cookie;
    }    
    return(hash);
}
