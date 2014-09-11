//http://demos.jquerymobile.com/1.0/docs/pages/page-scripting.html

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
  this.playable_cards = [];

  for( var i = 0; i < object.player_self.player_cards.length; i++) {
    playable_card = new PlayableCard(object.player_self.player_cards[i])
    this.playable_cards.push(playable_card);
  };
}

var Game = function(object) {
  this.game_id = object.game_id;
  this.round = new Round(object);
  this.game_name = object.game_name;
};

var Round = function(object) {
  this.active = object.active;
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

var GameRecap = function(object) {
  this.active = object.active;
  this.blackcard_content = object.blackcard_content;
  this.leader_email = object.leader_email;
  this.leader_id = object.leader_id;
  this.leader_name = object.leader_name;
  this.round_num = object.round_num;
  this.winner_email = object.winner_email;
  this.winner_id = object.winner_id;
  this.winner_name = object.winner_name;
  this.winner_whitecard = object.winner_whitecard;
  this.game_name = object.game_name
}

var GameRecapList = function(jsonResponse) {
  this.gameRecaps = [];
  for (var i = jsonResponse.length; i > 0; i--) {
    gameRecap = new GameRecap(jsonResponse[i-1])
    this.gameRecaps.push(gameRecap)
  };
}

//VIEW
var View = function() {

}

View.prototype = {

  drawHeader: function(game) {
    $('.game-header').text(game.game_name + " - Round " + game.round.round_num);
    // $('.leader-container .leader-name').text(leader.name);
    // $(".blackcard-content").text(leader.blackcard.content);
  },

  drawLeaderContainer: function(leader) {
    $('.leader-container .leader-name').text(leader.name);
    $(".blackcard-content").text(leader.blackcard.content);
  },

  drawPlayerList: function(game) {
    missing_submissions = game.round.missing_submissions;
    submissions = game.round.submissions;
    var listItem = $('.player-list ul li:first').clone();
    var listItemCopy = $('.player-list ul li:first').clone();
    $('.player-list ul li').remove();
    this.drawMissingSubmissions(listItem, missing_submissions);
    this.drawGivenSubmissions(listItemCopy, submissions);
  },

  drawMissingSubmissions: function(listItem, missing_submissions) {

    if (missing_submissions.length > 0) {
      for (var i = 0; i < missing_submissions.length; i++) {
        $('.player-list ul').append(listItem);
        listItem.find('.player-data .player-name').text(missing_submissions[i].player_name)
        listItem.find('.player-status').text(" has not submitted a white card.")
        listItem.find('.player-score').text(missing_submissions[i].player_score);
        var listItem = $('.player-list ul li:first').clone();
      };
    }
  },

  drawGivenSubmissions: function(listItem, submissions) {
    if (submissions.length > 0) {
      for (var i = 0; i < submissions.length; i++) {
        $('.player-list ul').append(listItem);
        listItem.find('.player-data .player-name').text(submissions[i].player_name)
        listItem.find('.player-status').text(" is in!")
        listItem.find('.player-score').text(submissions[i].player_score)
        var listItem = $('.player-list ul li:first').clone();
      };
    }
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

  drawSubmissionCards: function(game) {
    var cardElement = $('#choose .card-list li:first').clone();
    $('#choose .card-list li:first').remove();

    var submissionCards = game.round.submissions
    for (var i = 0; i < submissionCards.length; i++) {
      $('#choose .card-list').append(cardElement)
      var cardSubmitLink = "/api/users/" + $.cookie('session').user_id + "/games/" + game.game_id + "/cards/" + submissionCards[i].submission_id;
      cardElement.find('a').attr('href', cardSubmitLink )
      cardElement.find('.card-content').text(submissionCards[i].submission_content)
      var cardElement = $('#choose .card-list li:first').clone();
    }
  },

  drawRecap: function(game) {
    this.drawWinningSubmission(game);
    this.drawLosingSubmissions(game);
  },

  drawWinningSubmission: function(game) {
    var submissionDiv = $('.submission-winner-container ul li:first');
    submissionDiv.find(".player-name").text(game.round.winning_submission.player_name);
    submissionDiv.find(".player-card-content").text(game.round.winning_submission.submission_content);
  },

  drawLosingSubmissions: function(game) {
    var losingDiv = $(".submission-loser-container ul li:first").clone();
    $(".submission-loser-container ul li:first").remove();
    var losingSubmissions = game.round.losing_submissions
    for (var i = 0; i < losingSubmissions.length; i ++) {
      losingDiv.find(".player-name").text(losingSubmissions[i].player_name)
      losingDiv.find(".player-card-content").text(losingSubmissions[i].submission_content)
      $(".submission-loser-container ul").append(losingDiv)
      var losingDiv = $(".submission-loser-container ul li:first").clone();
    }
  },

  drawGameOverview: function(gameRecaps) {
    console.log(gameRecaps)
    listElement = $('#game-overview .prev-rounds-list ul')
    listItem = $('#game-overview .prev-rounds-list ul li').clone();
    $('#game-overview .prev-rounds-list ul li').empty();
    for (var i = 0; i < gameRecaps.length; i++) {
      if (gameRecaps[i].active === true) {
        this.drawOpenRoundHeader(gameRecaps[i])
      }
      else {
        listElement.append(listItem);
        listItem.find('.game-round').text(gameRecaps[i].round_num)
        listItem.find('a').attr('href', gameRecaps[i].round_num)
        // debugger
        listItem.find('.leader-name').text(gameRecaps[i].leader_name)
        listItem.find('.leader-blackcard-content').text(gameRecaps[i].blackcard_content)
        listItem = listItem.clone();
      }
    }
  },

  drawOpenRoundHeader: function(openRound) {
    $('#game-overview .play-round-btn-container .game-round').text(openRound.round_num)
  }
}


//CONTROLLER
var Controller = function(view) {
  this.bindEvents();
  this.view = view;
  this.user = null;
  this.game = null;
  this.leader = null;
  this.gameRecapList = null;
};

Controller.prototype = {

  delegateGame: function() {
    $.mobile.changePage("#game");
    // this.view.drawHeader(this.game, this.leader);
    this.view.drawHeader(this.game);
    this.view.drawLeaderContainer(this.leader);
    if (this.user.need_submission === false) {
      $('.choose-button-container').hide()
    }
    else {
      $('.choose-button-container').hide().show()
    }
    this.view.drawPlayerList(this.game);
  },

  delegateSubmission: function() {
    $.mobile.changePage("#choose");
    console.log("made it to delegate submission");
    this.view.drawHeader(this.game);
    this.view.drawLeaderContainer(this.leader);
    if (this.user.user_id == this.leader.user_id) {
      this.view.drawSubmissionCards(this.game);
    }
    else {
      this.view.drawPlayableCards(this.game, this.user);
    };
  },

  delegateRecap: function() {
    $.mobile.changePage("#recap");
    this.view.drawHeader(this.game);
    this.view.drawLeaderContainer(this.leader);
    this.view.drawRecap(this.game);
  },

  delegateGameOverview: function() {
    $.mobile.changePage("#game-overview");
    // this.view.drawHeader(this.gameRecapList.gameRecaps[0]);

    this.view.drawGameOverview(this.gameRecapList.gameRecaps)
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

  getGameOverview: function(event) {
    event.preventDefault();
    var initiator_id = $.cookie('session').user_id
    var game_id = $.cookie('session').game_ids[0]
    var url = "/api/games/" + game_id + "/recap";
    var posting = $.get(url, { "user_id": initiator_id });
    posting.done(function( data ) {
      this.gameRecapList = new GameRecapList(data)
      this.delegateGameOverview();
    }.bind(this));

  },

  getPreviousRoundRecap: function(event) {
    event.preventDefault();
    var round_num = null
    if (!$(event.target.parents).hasClass("prev-rounds-list")) {
      var el = $(event.target).parents('.game-round-link')[0];
      round_num = parseInt($(el).attr('href'));
    }
    else {
      debugger
    }
    debugger
    console.log('made it')
    var initiator_id = $.cookie('session').user_id
    var game_id = $.cookie('session').game_ids[0]
    url = "/api/games/" + game_id + "/rounds/" + round_num;

    var posting = $.get(url, { "user_id": initiator_id });
    posting.done(function( data ) {
      console.log(data);
      this.parseAjaxResponse(data);

      this.delegateRecap();
    }.bind(this));
  },

  getCurrentGameState: function(event) {
    event.preventDefault();
    var form = $(event.target);
    initiator_id = $.cookie('session').user_id
    game_id = $.cookie('session').game_ids[0]
    url = "/api/games/" + game_id;
    var posting = $.get(url, { "user_id": initiator_id } );
    posting.done(function( data ) {
      console.log(data);
      this.parseAjaxResponse(data);
      this.delegateGame();
      console.log("current game state fetched");

    }.bind(this));
  },

  makeSubmission: function(event) {
    event.preventDefault();
    var htmlLink = $(event.target).attr('href')
    var array = htmlLink.split("/");
    var card_id = parseInt(array[array.length-1])
    var initiator_id = $.cookie('session').user_id
    var game_id = $.cookie('session').game_ids[0];
    url = "/api/games/" + game_id + "/cards/" + card_id;

    var posting = $.post(url,  { "user_id": initiator_id });
    posting.done(function( data ) {
      this.parseAjaxResponse(data);

      console.log(data)
      if ( this.game.round.active ) {
        this.delegateGame();
      }
      else {
        this.delegateRecap();
      }
    }.bind(this));
  },

  bindEvents: function() {
    $("#game-overview .play-round-btn").on('click', this.getCurrentGameState.bind(this));
    $('#game .choose-button-container a').on('click', this.delegateSubmission.bind(this));
    $('#active-games-group a').on('click',  this.getGameOverview.bind(this))
    $('#choose .listview').on('click', 'li a.card-link', this.makeSubmission.bind(this));
    $("#game #game-refresh").on('click', this.getCurrentGameState.bind(this));
    $("#game-overview .prev-rounds-list").on('click', this.getPreviousRoundRecap.bind(this))
  }
}


// ------------ GLOBAL -----------
$.cookie.json = true;

var bindCreateUser = function($submit, $user_name, $user_password, $user_phone, $user_email) {
  $submit.on("click", function(event) {
    var user_name = $user_name.val();
    var user_password = $user_password.val();
    var user_phone = $user_phone.val();
    var user_email = $user_email.val();
    event.preventDefault();
    console.log("Running User Creation");
    $.ajax({
      type: "POST",
      url: '/api/users/new',
      data: {name:user_name,password:user_password,email:user_email,phone:user_phone}
    })
    .done(function(response){
      var cookie = { "user_id": response.user_id,
                     "token": response.token };
      $.cookie('session', cookie);
      setTimeout(
        function(){
          $.mobile.changePage("#user");
          location.reload();
        },100
      );
    })
    .fail(function(jqXHR,response){
      alert("Account creation failed");
    })
  });
}

var bindClearCookie = function($el) {
  $el.on("click", function(event) {
    console.log("Running bindClearCookie event");
    $.removeCookie('session');
    location.reload();
  });
};

var bindSetCookie = function($submit, $user_id, $user_password, $game_ids) {
  $submit.on("click", function(event) {
    console.log("Running bindSetCookie event");
    var user_id = $user_id.val();
    var user_password = $user_password.val();
    var game_ids = $game_ids.val().split(",");
    for (var a in game_ids ) { game_ids[a] = parseInt(game_ids[a], 10); }
    $.ajax({
      type: "POST",
      url: '/api/users/signin',
      data: {user_id:user_id,password:user_password}
    })
    .done(function(response){
      var cookie = { "user_id": user_id,
                     "game_ids": game_ids,
                     "token": response.token };
      $.cookie('session', cookie);
      setTimeout(
        function(){
          location.reload();
        },100
      );
    })
    .fail(function(jqXHR,response){
      alert("Signin failed");
    })
  });
};

// --------------------------------------
// --------- PAGE INITIALIZERS ----------
// --------------------------------------

// HOME


// USER
$( document ).delegate("#create-account", "pageinit", function() {
  bindCreateUser( $("#user-create-button"),$("#user-name"),$("#user-password"),$("#user-phone"),$("#user-email") );
});

$( document ).delegate("#user", "pageinit", function() {
  console.log("INIT RUNNING!")
  $('#user').trigger('create')
  cookie = $.cookie('session');
  bindSetCookie( $("#cookie-submit"),$("#cookie-user-id"),$("#cookie-user-password"),$("#cookie-game-ids") );
  bindClearCookie( $("#cookie-clear") );
  bindClearCookie( $(".user-logout") );
  if (cookie) {
    console.log("Detected cookie.")
    $(".login").hide();
    $(".create-account").hide();
    $(".user-logout").show();
    $(".create-game").show();
  }
  else {
    console.log("No cookie tected.")
    $(".login").show();
    $(".create-account").show();
    $(".user-logout").hide();
    $(".create-game").hide();
  }
});
