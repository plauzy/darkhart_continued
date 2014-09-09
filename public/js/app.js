// http://jqmtricks.wordpress.com/2014/03/26/jquery-mobile-page-events/




//MODELS
var PlayableCard = function(object) {
  this.id = object.playable_card_id;
  this.content = object.content;
}

var User = function(object) {
  this.need_submission = object.need_submission;
  this.user_id = object.player_self.user_id;
  this.seat_id = object.player_self.seat_id;
  this.name = object.player_self.player_name;
  this.score = object.player_self.player_score;
  this.email = object.player_self.player_email;
  this.playable_cards = []
  for( var i = 0; i < object.player_self.player_cards.length; i++) {
    playable_card = new PlayableCard(object.player_self.player_cards[i])
    this.playable_cards.push(playable_card);
  };
}

var Game = function(object) {
  this.game_id = object.game_id;
  this.round = new Round(object);
  this.active = object.active;
  this.game_name = object.game_name;
};

var Round = function(object) {
  this.round_num = object.round;
  this.submissions = object.submissions;
  this.missing_submissions = object.missing_submissions;
  this.winning_submission = object.winning_submission;
  this.losing_submissions = object.losing_submissions;
};

var Leader = function(object) {
  this.name = object.leader_name;
  this.user_id = object.leader_user_id;
  this.email = object.leader_email;
  this.seat_id = object.leader_seat_id;
  this.blackcard = new Blackcard(object);
};

var Blackcard = function(object) {
  this.content = object.blackcard_content
}

//CONTROLLER
$(document).on("ready page:load", function() {
  var view = new View;
  var controller = new Controller(view);
});


// $(document).on( "beforepageshow", "#user", function() {
//   var controller = new Controller;
// });


var Controller = function(view) {
  this.bindEvents();
  this.view = view;
  this.user;
  this.game;
  this.leader;
};



var View = function() {
  
}

View.prototype = {

  drawHeader: function(game, leader) {
    $('.game-header').text(game.game_id);
    $('.leader-container .leader-name').text(leader.name);
    $(".blackcard-content").text(leader.blackcard.content); 
  },

  drawPlayerList: function(game) {
    missing_submissions = game.round.missing_submissions;
    submissions = game.round.submissions;

    var listItem = $('.player-list ul li:first').clone();
    $('.player-list ul li:first').remove();

    this.drawMissingSubmissions(listItem, missing_submissions);
    this.drawGivenSubmissions(listItem, submissions);

    // for (var i = 0; i < missing_submissions.length; i++) {
    //   $('.player-list ul').append(listItem);
    //   listItem.find('.player-data .player-name').text(missing_submissions[i].player_name)
    //   listItem.find('.player-status').text(" has not submitted a white card.")
    //   listItem.find('.player-score').text(missing_submissions[i].player_score)
    //   var listItem = $('.player-list ul li:first').clone();
    // };

    // for (var i = 0; i < submissions.length; i++) {
    //   $('.player-list ul').append(listItem);
    //   listItem.find('.player-data .player-name').text(submissions[i].player_name)
    //   listItem.find('.player-status').text(" is in!")
    //   listItem.find('.player-score').text(submissions[i].player_score)
    //   var listItem = $('.player-list ul li:first').clone();
    // };    
  },

  drawMissingSubmissions: function(listItem, missing_submissions) {
    for (var i = 0; i < missing_submissions.length; i++) {
      $('.player-list ul').append(listItem);
      listItem.find('.player-data .player-name').text(missing_submissions[i].player_name)
      listItem.find('.player-status').text(" has not submitted a white card.")
      listItem.find('.player-score').text(missing_submissions[i].player_score)
      var listItem = $('.player-list ul li:first').clone();
    };
  },

  drawGivenSubmissions: function(listItem, submissions) {
    for (var i = 0; i < submissions.length; i++) {
      $('.player-list ul').append(listItem);
      listItem.find('.player-data .player-name').text(submissions[i].player_name)
      listItem.find('.player-status').text(" is in!")
      listItem.find('.player-score').text(submissions[i].player_score)
      var listItem = $('.player-list ul li:first').clone();
    };  
  },

  otherFunction: function(){

  }
}




Controller.prototype = {

  delegateGame: function() {
    $.mobile.changePage("#game");
    this.view.drawHeader(this.game, this.leader)

    if (!this.user.need_submission) {
      $('.choose-button-container').hide()
    }
    this.view.drawPlayerList(this.game);
    // this.buildOtherPlayerStatuses();
  },

  buildOtherPlayerStatuses: function() {
    missing_submissions = this.game.round.missing_submissions;
    submissions = this.game.round.submissions;
    var listItem = $('.player-list ul li:first').clone();
    $('.player-list ul li:first').remove();

    for (var i = 0; i < missing_submissions.length; i++) {
      $('.player-list ul').append(listItem);
      listItem.find('.player-data .player-name').text(missing_submissions[i].player_name)
      listItem.find('.player-status').text(" has not submitted a white card.")
      listItem.find('.player-score').text(missing_submissions[i].player_score)
      var listItem = $('.player-list ul li:first').clone();
    };

    for (var i = 0; i < submissions.length; i++) {
      $('.player-list ul').append(listItem);
      listItem.find('.player-data .player-name').text(submissions[i].player_name)
      listItem.find('.player-status').text(" is in!")
      listItem.find('.player-score').text(submissions[i].player_score)
      var listItem = $('.player-list ul li:first').clone();
    }    
  },

  delegateSubmission: function() {
    $.mobile.changePage("#choose");
    this.view.drawHeader(this.game, this.leader)
    // $('.game-header').text(this.game.game_id);
    // $('.leader-container .leader-name').text(this.leader.name);
    // $(".blackcard-content").text(this.leader.blackcard.content);

    var cardElement = $('#choose .card-list li:first').clone();
    $('#choose .card-list li:first').remove();

    var playable_cards = this.user.playable_cards
    for (var i = 0; i < playable_cards.length; i++) {
      $('#choose .card-list').append(cardElement)
      var cardSubmitLink = "/api/users/" + $.cookie('session').user_id + "/games/" + this.game.game_id + "/cards/" + playable_cards[i].id;
  
      cardElement.find('a').attr('href', cardSubmitLink )
      cardElement.find('.card-content').text(playable_cards[i].content)
      var cardElement = $('#choose .card-list li:first').clone();

    }
  },

  delegateRecap: function() {
    $.mobile.changePage("#recap");
    $(".game-round").text(this.game.game_id);
    $(".leader-info").text(this.leader.name + " has the black card");
    $(".blackcard-content").text(this.leader.blackcard.content);

    //needs to create element
    var winning_div = $(".submission-winner-container ul");
    var winning_submission = this.game.round.winning_submission.submission_content
    winning_div.append(winning_submission)
    var losing_div = $(".submission-loser-container ul");
    losing_submissions = this.game.round.losing_submissions
    for (var i = 0; i < losing_submissions.length; i ++) {
      losing_div.append(losing_submissions[i].submission_content)
    }
  },

  parseAjaxResponse: function(data) {
    this.user = new User(data)
    this.game = new Game(data)
    this.leader = new Leader(data.leader)
    this.delegateGame();
  },

  createGame: function(event) {
    event.preventDefault();
    var form = $(event.target);
    initiator_id = form.find( "input[name='initiator_id']" ).val();
    invite_ids = form.find( "input[name='invite_ids']" ).val();
    game_name = form.find( "input[name='game_name']" ).val();
    url = "/api/users/" + initiator_id + "/games";

    var posting = $.post( url, { "invite_ids": invite_ids,
                                  "game_name": game_name } );
    posting.done(function( data ) {
      $("#json").empty().append(JSON.stringify(data, undefined, 2))
      console.log(data);
      this.parseAjaxResponse(data)
    }.bind(this));
  },

  getPreviousRoundRecap: function(event) {
    event.preventDefault();
    var form = $(event.target);
    initiator_id = form.find( "input[name='initiator_id']" ).val();
    game_id=  form.find( "input[name='game_id']" ).val();
    round_num = form.find( "input[name='round_num']").val();
    url = "/api/users/" + initiator_id + "/games/" + game_id + "/rounds/" + round_num;

    var posting = $.get(url);
    posting.done(function( data ) {
      $("#json").empty().append(JSON.stringify(data, undefined, 2))
      console.log(data);
      this.parseAjaxResponse(data)
    }.bind(this));

  },

  getCurrentGameState: function(event) {
    var form = $(event.target);
    initiator_id = $.cookie('session').user_id
    game_id = $.cookie('session').game_ids[0]
    url = "/api/users/" + initiator_id + "/games/" + game_id;
    var posting = $.get( url);
    posting.done(function( data ) {
      console.log(data);
      this.parseAjaxResponse(data)
    }.bind(this));
  },

  makeSubmission: function(event) {
    event.preventDefault();
    var form = $(event.target);
    initiator_id = form.find( "input[name='initiator_id']" ).val();
    game_id = form.find( "input[name='game_id']" ).val();
    card_id = form.find( "input[name='card_id']" ).val();
    url = "/api/users/" + initiator_id + "/games/" + game_id + "/cards/" + card_id;
    var posting = $.get(url);

    posting.done(function( data ) {
      $("#json").empty().append(JSON.stringify(data, undefined, 2))
      console.log(data);
      this.parseAjaxResponse(data)
    }.bind(this));
  },

  bindEvents: function() {
    $("#newGameForm").on("submit", this.createGame.bind(this))
    $("#previousRoundRecap").on("submit", this.getPreviousRoundRecap.bind(this))
    $("#game1").on("click", this.getCurrentGameState.bind(this))
    $("#makeSubmission").on("submit", this.makeSubmission.bind(this))
  }
}


 
// ------------ GLOBAL -----------
$.cookie.json = true;



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

// --------------------------------------
// --------- PAGE INITIALIZERS ----------
// --------------------------------------

// HOME


// USER


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
    console.log("No cookie tected.")
    $(".login").show();
    $(".create-account").show();
    $(".user-logout").hide();
  }
});

