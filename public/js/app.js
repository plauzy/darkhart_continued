// Cookie Management
// Setup cookies on login page.
$.cookie.json = true;
$("#cookie-submit").on("click", function(event) {
  event.preventDefault();
  var game_ids = $("#cookie-game_ids").val().split(",")
  for (a in game_ids ) { game_ids[a] = parseInt(game_ids[a], 10); };
  var cookie = { "user_id": $("#cookie-user_id").val(),
                 "game_ids": game_ids };
  console.log(cookie)
  $.cookie('session', cookie);
  console.log("Setting cookie for " + $("#cookie-user_id").val());
})

$("#cookie-clear").on("click", function(event) {
  event.preventDefault();
  $.removeCookie('session');
  console.log("Removing cookie.");
})

// Create game cookie on game page.

// $( document ).delegate("#aboutPage", "pagebeforecreate", function() {




// $( document ).delegate("#aboutPage", "pageinit", function() {
//   alert('A page with an id of "aboutPage" was just created by jQuery Mobile!');
// });


// $( document ).delegate("#aboutPage", "pagebeforecreate", function() {
//   alert('A page with an id of "aboutPage" is about to be created by jQuery Mobile!');
// });
