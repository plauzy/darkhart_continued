// ------------ GLOBAL -----------
$.cookie.json = true;

var bindClearCookie = function($el) {
  $el.on("click", function(event) {
    event.preventDefault();
    console.log("Running bindClearCookie event");
    $.removeCookie('session');
    $.mobile.changePage('#home', { reloadPage: true });

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
  });
};

// Partials

// var html_logout = $("<a href='#home' class='ui-btn user_logout'>Logout</a>");

// var html_login = "<a href='#create_account' class='ui-btn'>Create Account</a>" +
//                 "<a href='#login' class='ui-btn'>Login</a>";

// success:function(result){
//     $("#tab7 form").after(html);
//     $('#add-notes-form textarea').attr('value','');
// }


// -------------- HOME -----------------
// Home partials




// Home on load
$( document ).delegate("#home", "pageinit", function() {
  console.log("INIT RUNNING!")
  $('#home').trigger('create')
  cookie = $.cookie('session');
  bindSetCookie( $("#cookie-submit"),$("#cookie-user-id"),$("#cookie-game-ids") );
  bindClearCookie( $("#cookie-clear") );
  bindClearCookie( $(".user-logout") );
  if (cookie) {
    console.log("Detected cookie.")
    $("#cookie").show();
    $("#no-cookie").hide();
  }
  else {
    console.log("No cookie detected.")
    $("#no-cookie").show();
    $("#cookie").hide();
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
