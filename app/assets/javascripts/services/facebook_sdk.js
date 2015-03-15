window.fbAsyncInit = function() {
  // init the FB JS SDK
  FB.init({
    appId      : '418680344889116',                     // App ID from the app dashboard
    status     : false,
    oauth      : false,                                 // enable OAuth 2.0
    cookie     : true,
    xfbml      : false                                  // Look for social plugins on the page
  });

  // Additional initialization code such as adding Event Listeners goes here
};

// Load the SDK asynchronously
(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement(s); js.id = id;
   js.src = "//connect.facebook.net/en_US/all.js";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk'));
