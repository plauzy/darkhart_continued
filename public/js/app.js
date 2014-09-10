$(document).on("ready page:load", function() {
  var view = new View;
  var controller = new Controller(view);
});

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

//VIEW
var View = function() {

}

View.prototype = {

  drawHeader: function(game, leader) {
    $('.game-header').text("NAME HERE - Round " + game.round.round_num);
    $('.leader-container .leader-name').text(leader.name);
    $(".blackcard-content").text(leader.blackcard.content);
  },

  drawPlayerList: function(game) {
    missing_submissions = game.round.missing_submissions;
    submissions = game.round.submissions;
    this.drawMissingSubmissions(missing_submissions);
    this.drawGivenSubmissions(submissions);
  },

  drawMissingSubmissions: function(missing_submissions) {
    var listItem = $('.player-list ul li:first').clone();
    $('.player-list ul li:first').remove();
    for (var i = 0; i < missing_submissions.length; i++) {
      $('.player-list ul').append(listItem);
      listItem.find('.player-data .player-name').text(missing_submissions[i].player_name)
      listItem.find('.player-status').text(" has not submitted a white card.")
      listItem.find('.player-score').text(missing_submissions[i].player_score);
      var listItem = $('.player-list ul li:first').clone();
    };
  },

  drawGivenSubmissions: function(submissions) {
    var listItem = $('.player-list ul li:first').clone();
    for (var i = 0; i < submissions.length; i++) {
      $('.player-list ul').append(listItem);
      listItem.find('.player-data .player-name').text(submissions[i].player_name)
      listItem.find('.player-status').text(" is in!")
      listItem.find('.player-score').text(submissions[i].player_score)
      var listItem = $('.player-list ul li:first').clone();
    };
  },

  drawPlayableCards: function(game, user){
    var cardElement = $('#choose .card-list li:first').clone();
    $('#choose .card-list li:first').remove();

    var playable_cards = user.playable_cards
    for (var i = 0; i < playable_cards.length; i++) {
      $('#choose .card-list').append(cardElement)
      var cardSubmitLink = "/api/users/" + $.cookie('session').user_id + "/games/" + game.game_id + "/cards/" + playable_cards[i].id;
      cardElement.find('a').attr('href', cardSubmitLink )
      cardElement.find('.card-content').text(playable_cards[i].content)
      var cardElement = $('#choose .card-list li:first').clone();
    }
  },

  drawRecap: function(game) {
    game.round.winning_submission = "MEOW"
    game.round.winning_submission.card_content = "tits"

    //Draw winning submission
    var submissionDiv = $('.submission-winner-container ul li:first')
    submissionDiv.find(".player-name").text("Winner to go Here")
    submissionDiv.find(".player-card-content").text("Winning Content to go here")

    //Draw losing submissions
    game.round.losing_submissions = [1,2,3]
    var losingDiv = $(".submission-loser-container ul li:first").clone();
    $(".submission-loser-container ul li:first").remove();
    losingSubmissions = game.round.losing_submissions
    for (var i = 0; i < losingSubmissions.length; i ++) {
      losingDiv.find(".player-name").text("Meow")
      losingDiv.find(".player-card-content").text("titties......")
      $(".submission-loser-container ul").append(losingDiv)
      var losingDiv = $(".submission-loser-container ul li:first").clone();
    }
  }
}

//CONTROLLER
var Controller = function(view) {
  this.bindEvents();
  this.view = view;
  this.user;
  this.game;
  this.leader;
};

Controller.prototype = {

  delegateGame: function() {
    $.mobile.changePage("#game");
    this.view.drawHeader(this.game, this.leader);
    if (!this.user.need_submission) {
      $('.choose-button-container').hide()
    }
    this.view.drawPlayerList(this.game);
  },

  delegateSubmission: function() {
    $.mobile.changePage("#choose");
    console.log("made it to delegate submission");
    debugger
    this.view.drawHeader(this.game, this.leader);

    this.view.drawPlayableCards(this.game, this.user);
  },

  delegateRecap: function() {
    $.mobile.changePage("#recap");
    this.view.drawHeader(this.game, this.leader);
    this.view.drawRecap(this.game)
  },

  parseAjaxResponse: function(data) {
    this.user = new User(data)
    this.game = new Game(data)
    this.leader = new Leader(data.leader)
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
    event.preventDefault();
    var form = $(event.target);
    initiator_id = $.cookie('session').user_id
    game_id = $.cookie('session').game_ids[0]
    url = "/api/users/" + initiator_id + "/games/" + game_id;
    var posting = $.get( url);
    posting.done(function( data ) {
      console.log(data);
      this.parseAjaxResponse(data);
      this.delegateGame();
      console.log("current game state fetched");

    }.bind(this));
  },

  makeSubmission: function(event) {
    event.preventDefault();
    var form = $(event.target);
    initiator_id = $.cookie('session').user_id
    game_id = $.cookie('session').game_ids[0]
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
    $("#game-overview .play-round-btn").on('click', this.getCurrentGameState.bind(this));
    $('#game .choose-button-container a').on('click', this.delegateSubmission.bind(this));

    //Saving for refactoring later
    // $("#newGameForm").on("submit", this.createGame.bind(this))
    // $("#previousRoundRecap").on("submit", this.getPreviousRoundRecap.bind(this))
    // $("#active-games-group a").on('click', this.getCurrentGameState.bind(this))
    // $("#makeSubmission").on("submit", this.makeSubmission.bind(this))
  }
}


// ------------ GLOBAL -----------
$.cookie.json = true;

var bindClearCookie = function($el) {
  $el.on("click", function(event) {
    console.log("Running bindClearCookie event");
    $.removeCookie('session');
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
