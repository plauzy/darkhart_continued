

$(function() {
  $( "#usersListForm" ).submit(function( event ) {
      // $( "#usersListForm" ).submit(function( event ) {
    event.preventDefault();
    var $form = $( this ),
      initiator_id = $form.find( "input[name='initiator_id']" ).val();
      url = "/api/users/";

      var posting = $.get(url, { "user_id": initiator_id });
    // Put the results in a div
    posting.done(function( data ) {
      $("#json").empty().append(JSON.stringify(data, undefined, 2));
    });
  });

  $( "#newGameForm" ).submit(function( event ) {
    event.preventDefault();
    var $form = $( this ),
      initiator_id = $form.find( "input[name='initiator_id']" ).val();
      invite_ids = $form.find( "input[name='invite_ids']" ).val();
      game_name = $form.find( "input[name='game_name']" ).val();
      url = "/api/games/";
      var posting = $.post( url, {  "user_id": initiator_id,
                                    "invite_ids": invite_ids,
                                    "game_name": game_name } );
      console.log(posting);

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
      game_id=  $form.find( "input[name='game_id']" ).val();
      round_num = $form.find( "input[name='round_num']").val();
      console.log(round_num)
      url = "/api/games/" + game_id + "/rounds/" + round_num;
      var posting = $.get(url, { "user_id": initiator_id });

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
      game_id = $form.find( "input[name='game_id']" ).val();
      url = "/api/games/" + game_id;

      var posting = $.get(url, { "user_id": initiator_id });
    // Put the results in a div
    posting.done(function( data ) {
      $("#json").empty().append(JSON.stringify(data, undefined, 2))

    });
  });

  $( "#gameRecap" ).submit(function( event ) {
    event.preventDefault();
    var $form = $( this ),
      initiator_id = $form.find( "input[name='initiator_id']" ).val();
      game_id = $form.find( "input[name='game_id']" ).val();
      url = "/api/games/" + game_id + "/recap";

      var posting = $.get(url, { "user_id": initiator_id, "game_id": game_id });
    // Put the results in a div
    posting.done(function( data ) {
      $("#json").empty().append(JSON.stringify(data, undefined, 2))

    });
  });


  $( "#gameInventory" ).submit(function( event ) {
    event.preventDefault();
    var $form = $( this ),
      initiator_id = $form.find( "input[name='initiator_id']" ).val();
      url = "/api/users/" + initiator_id;

      var posting = $.get(url, { "user_id": initiator_id });
      console.log(initiator_id)
    // Put the results in a div
    posting.done(function( data ) {
      $("#json").empty().append(JSON.stringify(data, undefined, 2))
      console.log(data);
    });
  });

  $( "#makeSubmission" ).submit(function( event ) {
    event.preventDefault();
    var $form = $( this ),
      initiator_id = $form.find( "input[name='initiator_id']" ).val();
      game_id = $form.find( "input[name='game_id']" ).val();
      card_id = $form.find( "input[name='card_id']" ).val();
      url = "/api/games/" + game_id + "/cards/" + card_id;

      var posting = $.get(url, { "user_id": initiator_id });
    // Put the results in a div
    posting.done(function( data ) {
      $("#json").empty().append(JSON.stringify(data, undefined, 2))
      console.log(data);
    });
  });

  $( "#makeDecision" ).submit(function( event ) {
    event.preventDefault();
    var $form = $( this ),
      initiator_id = $form.find( "input[name='initiator_id']" ).val();
      game_id = $form.find( "input[name='game_id']" ).val();
      card_id = $form.find( "input[name='submission_id']" ).val();
      url = "/api/games/" + game_id + "/round/" + round_id; // PATCH to update the round, probably also updates the game as well.
    var dataBlob = {
      "initiator_id": initiator_id,
      "game_id": game_id,
      "card_id": card_id,
      "_method": "PATCH"
    };

    var posting = $.post(url, dataBlob);
    // Put the results in a div
    posting.done(function( data ) {
      $("#json").empty().append(JSON.stringify(data, undefined, 2))
      console.log(data);
    });
  });
});
