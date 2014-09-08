$( "#newGameForm" ).submit(function( event ) {
  event.preventDefault();
  var $form = $( this ),
    initiator_id = $form.find( "input[name='initiator_id']" ).val();
    invite_ids = $form.find( "input[name='invite_ids']" ).val();
    game_name = $form.find( "input[name='game_name']" ).val();
    url = "/api/users/" + initiator_id + "/games";

    var posting = $.post( url, {  "invite_ids": invite_ids,
                                  "game_name": game_name } );
  // Put the results in a div
  posting.done(function( data ) {
    $("#json").empty().append(JSON.stringify(data, undefined, 2))
    console.log(data);
  });
});

$( "#previousRoundRecap" ).submit(function( event ) {
  event.preventDefault();
  var $form = $( this ),
    initiator_id = $form.find( "input[name='initiator_id']" ).val();
    game_id= $form.find( "input[name='game_id']" ).val();
    round_num = $form.find( "input[name='round_num']").val();
    url = "/api/users/" + initiator_id + "/games/" + game_id + "/rounds/" + round_num;

    var posting = $.get( url);
  // Put the results in a div
  posting.done(function( data ) {
    $("#json").empty().append(JSON.stringify(data, undefined, 2))
    console.log(data);
  });
});

$( "#currentGameState" ).submit(function( event ) {
  event.preventDefault();
  var $form = $( this ),
    initiator_id = $form.find( "input[name='initiator_id']" ).val();
    game_id= $form.find( "input[name='game_id']" ).val();
    url = "/api/users/" + initiator_id + "/games/" + game_id;

    var posting = $.get( url);
  // Put the results in a div
  posting.done(function( data ) {
    $("#json").empty().append(JSON.stringify(data, undefined, 2))
    console.log(data);
  });
});

