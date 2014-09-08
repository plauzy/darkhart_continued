$( "#newGameForm" ).submit(function( event ) {
  event.preventDefault();
  var $form = $( this ),
    initiator_id = $form.find( "input[name='initiator_id']" ).val();
    invite_ids = $form.find( "input[name='invite_ids']" ).val();
    game_name = $form.find( "input[name='game_name']" ).val();
    url = "/api/users/" + initiator_id + "/games";

    var posting = $.post( url, {  "initiator_id": initiator_id,
                                  "invite_ids": invite_ids,
                                  "game_name": game_name } );
  // Put the results in a div
  posting.done(function( data ) {
    var content = $( data ).find( "#content" );
    $( "#json" ).empty().append( content );
  });
});
