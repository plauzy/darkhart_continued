// ------------ GLOBAL -----------
$.cookie.json = true;

// $(document).bind("mobileinit", function()
// {
//     $.mobile.page.prototype.options.domCache = false;
//     $.mobile.ajaxEnabled = true;
//     $.mobile.changePage.defaults.reloadPage = true;
// });

var bindClearCookie = function($el) {
  $el.on("click", function(event) {
    console.log("Running bindClearCookie event");
    $.removeCookie('session');
    // $("#user").trigger("create");
    location.reload();
  });
};

var bindSetCookie = function($submit, $user_id, $game_ids) {
  $submit.on("click", function(event) {
    console.log("Running bindSetCookie event");
    var game_ids = $game_ids.val().split(",");
    for (var a in game_ids ) { game_ids[a] = parseInt(game_ids[a], 10); }
    var cookie = { "user_id": $user_id.val(),
                   "game_ids": game_ids };
    $.cookie('session', cookie);
    // $("#user").trigger("create");
    setTimeout(
      function(){
        location.reload();
      },100
    );
  });
};

// Partials

// var html_logout = $("<a href='#user' class='ui-btn user_logout'>Logout</a>");

// var html_login = "<a href='#create_account' class='ui-btn'>Create Account</a>" +
//                 "<a href='#login' class='ui-btn'>Login</a>";

// success:function(result){
//     $("#tab7 form").after(html);
//     $('#add-notes-form textarea').attr('value','');
// }


// -------------- HOME -----------------
// Home partials




// Home on load
$( document ).delegate("#user", "pageinit", function() {
  console.log("INIT RUNNING!")
  $('#user').trigger('create')
  cookie = $.cookie('session');
  bindSetCookie( $("#cookie-submit"),$("#cookie-user-id"),$("#cookie-game-ids") );
  bindClearCookie( $("#cookie-clear") );
  bindClearCookie( $(".user-logout") );
  if (cookie) {
    console.log("Detected cookie.")
    $(".login").hide();
    $(".create-account").hide();
    $(".user-logout").show();
  }
  else {
    console.log("No cookie detected.")
    $(".login").show();
    $(".create-account").show();
    $(".user-logout").hide();
  }
});


// Cookie Management
// Setup cookies on login page.







// Create game cookie on game page.

// $( document ).delegate("#aboutPage", "pagebeforecreate", function() {




// $( document ).delegate("#aboutPage", "pageinit", function() {
//   alert('A page with an id of "aboutPage" was just created by jQuery Mobile!');
// });


// $( document ).delegate("#aboutPage", "pagebeforecreate", function() {
//   alert('A page with an id of "aboutPage" is about to be created by jQuery Mobile!');
// });
