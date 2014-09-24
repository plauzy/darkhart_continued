$.cookie.json = true;

$(document).on("ready page:load", function() {
  var view = new View;
  var controller = new Controller(view);
});


var gameId = function(){
  var cookie = $.cookie('game')
  if (cookie != null) { return parseInt(cookie.game_id)}
  else { return null };
};

var gravatar = function(email) {
  return "http://www.gravatar.com/avatar/" + MD5(email)
};

var userId = function() {
  var cookie = $.cookie('session')
  if (cookie != null) { return parseInt(cookie.user_id)}
  else { return null };
};

//MODELS
var UserCookie = function(user_id, token) {
  this.user_id = user_id;
  this.token = token;
  this.cookie = $.cookie('session', {"user_id": user_id, "token": token })
};

UserCookie.prototype = {
  remove: function() { $.removeCookie('session') },
};

var GameCookie = function(id) {
  this.game_id = id
  this.cookie = $.cookie('game', { "game_id": id })
};

GameCookie.prototype = {
  remove: function() { $.removeCookie('game') },
};

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
  this.gravatar = gravatar(object.player_self.player_email);
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
  this.gravatar = gravatar(object.leader_email);
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
  this.leader_gravatar = gravatar(object.leader_email);
  this.leader_id = object.leader_id;
  this.leader_name = object.leader_name;
  this.round_num = object.round_num;
  this.winner_email = object.winner_email;
  this.winner_id = object.winner_id;
  this.winner_name = object.winner_name;
  // this.winner_gravatar = "http://www.gravatar.com/avatar/" + MD5(object.winner_email);

  this.winner_whitecard = object.winner_whitecard;
  this.game_name = object.game_name
}

var GameRecapList = function(jsonResponse) {
  this.gameRecaps = [];
  for (var i = jsonResponse.length; i > 0; i--) {
    gameRecap = new GameRecap(jsonResponse[i-1]);
    this.gameRecaps.push(gameRecap);
  };
}

var UserGame = function(object) {
  this.game_id = object.game_id;
  this.active = object.active;
  this.current_round = object.current_round;
  this.need_submission = object.need_submission;
  this.leader_name = object.leader_name;
  this.leader_email = object.leader_email;
  this.leader_gravatar = gravatar(object.leader_email);
  this.winner_id = object.owner_user_id;
  this.game_name = object.game_name;
  this.winner_email = object.owner_email;
  this.winner_gravatar = gravatar(object.leader_email);
  this.winner_name = object.owner_name;
  this.winner_whitecard = object.card_content;
};

var UserGamesList = function(jsonResponse) {
  this.userGames = [];
  for (var i = jsonResponse.length; i > 0; i--) {
    userGame = new UserGame(jsonResponse[i-1]);
    this.userGames.push(userGame);
  }
};
//VIEW
var View = function() { }

View.prototype = {

  drawUserGames: function(games) {
    $('#active-games-group').empty()
    $('#inactive-games-group').empty()
    var game_html = "<a href='#game-overview' class='active-game ui-btn ui-icon-check ui-btn-icon-right' data-role='button' style='text-align: left'>Game</a>"
    for (var i = 0; i < games.userGames.length; i++) {
      var game = games.userGames[i]; // cookie.setGameId(game.game_id)
      var $game_html = $(game_html).text(game.game_name).attr("game_id", game.game_id);
      if (game.active == true && game.need_submission == true) {
        $('#active-games-group').append($game_html);
       }
      else if (game.active == true) {
        $('#active-games-group').append($game_html.removeClass('ui-icon-check ui-btn-icon-right'));
      }
      else {
        $('#inactive-games-group').append($game_html.removeClass('ui-icon-check ui-btn-icon-right'));
      }
      $('.active-game').on('click', function(event) { new GameCookie( $(this).attr('game_id') ) });
    }
  },

  drawHeader: function(game) {
    $('.game-header').text(game.game_name + " - Round " + game.round.round_num);
    $('.game-header').attr('data-attr', game.round.round_num)
  },

  drawLeaderContainer: function(leader) {
    $('.leader-container .leader-name').text(leader.name);
    $('.leader-container .avatar').attr('src', leader.gravatar);
    $(".blackcard-content").text(leader.blackcard.content);
  },

  drawPlayerList: function(game) {
    missing_submissions = game.round.missing_submissions;
    submissions = game.round.submissions;
    var listItem = $('.player-list ul li:first').clone();
    var listItemCopy = $('.player-list ul li:first').clone();
    $('.player-list ul').empty();
    this.drawMissingSubmissions(listItem, missing_submissions);
    this.drawGivenSubmissions(listItemCopy, submissions);
  },

  drawMissingSubmissions: function(listItem, missing_submissions) {

    if (missing_submissions.length > 0) {
      for (var i = 0; i < missing_submissions.length; i++) {
        $('.player-list ul').append(listItem);
        listItem.find('.player-data .player-name').text(missing_submissions[i].player_name);
        listItem.find('.player-status').text(" has not submitted a white card.");
        listItem.find('.avatar').attr("src", gravatar(missing_submissions[i].player_email));
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
        listItem.find('.avatar').attr("src", gravatar(submissions[i].player_email));
        listItem.find('.player-score').text(submissions[i].player_score)
        var listItem = $('.player-list ul li:first').clone();
      };
    }
  },


  drawPlayableCards: function(game, user){
    var cardElement = $('#choose .card-list li:first').clone();
    $('#choose .card-list').empty();

    var playable_cards = user.playable_cards
    for (var i = 0; i < playable_cards.length; i++) {
      $('#choose .card-list').append(cardElement)
      cardElement.find('a').attr('href', playable_cards[i].id)
      cardElement.find('.card-content').text(playable_cards[i].content)
      var cardElement = $('#choose .card-list li:first').clone();
    }
  },

  drawSubmissionCards: function(game) {
    var cardElement = $('#choose .card-list li:first').clone();
    $('#choose .card-list').empty();

    var submissionCards = game.round.submissions
    for (var i = 0; i < submissionCards.length; i++) {
      $('#choose .card-list').append(cardElement)
      cardElement.find('a').attr('href', submissionCards[i].submission_id )
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
    submissionDiv.find(".avatar-container .avatar").attr("src", gravatar(game.round.winning_submission.player_email))
    submissionDiv.find(".player-card-content").text(game.round.winning_submission.submission_content);
  },

  drawLosingSubmissions: function(game) {
    var losingDiv = $(".submission-loser-container ul li:first").clone();
    $(".submission-loser-container ul").empty();
    var losingSubmissions = game.round.losing_submissions
    for (var i = 0; i < losingSubmissions.length; i ++) {
      losingDiv.find(".player-name").text(losingSubmissions[i].player_name)
      losingDiv.find(".player-card-content").text(losingSubmissions[i].submission_content)
      losingDiv.find(".avatar-container .avatar").attr("src", gravatar(losingSubmissions[i].player_email))
      $(".submission-loser-container ul").append(losingDiv)
      var losingDiv = $(".submission-loser-container ul li:first").clone();
    }
  },

  drawGameOverview: function(gameRecaps) {
    listElement = $('#game-overview .prev-rounds-list ul')
    listItem = $('#game-overview .prev-rounds-list ul li').clone();
    $('#game-overview .prev-rounds-list ul').empty();
    for (var i = 0; i < gameRecaps.length; i++) {
      if (gameRecaps[i].active === true) {
        this.drawOpenRoundHeader(gameRecaps[i])
      }
      else {

        listElement.append(listItem);
        listItem.find('.game-round').text(gameRecaps[i].round_num)
        listItem.find('a').attr('href', gameRecaps[i].round_num)
        listItem.find('.leader-name').text(gameRecaps[i].leader_name)
        listItem.find('.round-recap-container .leader-avatar').attr("src", gameRecaps[i].leader_gravatar)
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
  this.bindPageCreates();
  this.view = view;
  this.user = null;
  this.game = null;
  this.leader = null;
  this.userGamesList = null;
  this.gameRecapList = null;
};

Controller.prototype = {

  accountManager: function() {
    if (userId() == null) {
      $(".login").show();
      $(".create-account").show();
      $(".user-logout").hide();
      $(".create-game").hide();
      $(".games-group").hide();
    }
    else {
      $(".games-group").show();
      $(".user-logout").show();
      $(".create-game").show();
      $(".login").hide();
      $(".create-account").hide();
    }
  },


  delegateGame: function() {
    $.mobile.changePage("#game");
    // this.view.drawHeader(this.game, this.leader);
    this.view.drawHeader(this.game);
    this.view.drawLeaderContainer(this.leader);
    if (this.user.need_submission === false) {
      $('.choose-button-container').hide()
      $('.game-submitted').show();
    }
    else {
      $('.choose-button-container').show()
      $('.game-submitted').hide();
    }
    this.view.drawPlayerList(this.game);
  },
  delegateUserGames: function() {
    $.mobile.changePage("#user");
    this.view.drawUserGames(this.userGamesList);
  },

  delegateSubmission: function() {
    $.mobile.changePage("#choose");
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
    $('#game-overview .game-header').text(this.gameRecapList.gameRecaps[0].game_name)
    this.view.drawGameOverview(this.gameRecapList.gameRecaps)
  },

  parseAjaxResponse: function(data) {
    this.user = new User(data)
    this.game = new Game(data)
    this.leader = new Leader(data.leader)
  },

  loginUser: function(data) {
    event.preventDefault();
    var user_email = $('#login-email').val();
    var user_password = $('#login-password').val();
    $.ajax({
      type: "POST",
      url: '/api/users/signin',
      data: { "user_email":user_email, "password":user_password}
    })
    .done( function(response) {
      this.userCookie = new UserCookie(response.user_id, response.token)
      this.getUserGames();
      setTimeout(
        function(){
          location.reload();
        },100 );
    }.bind(this))
      .fail(function(jqXHR,response){
        alert("Signin failed");
      })
  },

  logoutUser: function(data) {
    $.removeCookie('session');
    $.mobile.changePage('#user', { reloadPage: true });
    setTimeout(
      function(){
        location.reload();
      },100 );
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
      this.parseAjaxResponse(data)
    }.bind(this));
  },

  getGameOverview: function() {
    var url = "/api/games/" + gameId() + "/recap";
    var posting = $.get(url, { "user_id": userId() });
    posting.done(function( data ) {
      this.gameRecapList = new GameRecapList(data)
      this.delegateGameOverview();
    }.bind(this));
  },

  getPreviousRoundRecap: function(event) {
    event.preventDefault();
    var round_num = null;
    if (!$(event.target.parents).hasClass("prev-rounds-list")) {
      var el = $(event.target).parents('.game-round-link')[0];
      round_num = parseInt($(el).attr('href'));
    };
    url = "/api/games/" + gameId() + "/rounds/" + round_num;
    var posting = $.get(url, { "user_id": userId() });
    posting.done(function( data ) {    
      this.parseAjaxResponse(data);
      this.delegateRecap();
    }.bind(this));
  },

  getCurrentGameState: function() {
    url = "/api/games/" + gameId();
    var posting = $.get(url, { "user_id": userId() } );
    posting.done(function( data ) {
      this.parseAjaxResponse(data);
      this.delegateGame();
    }.bind(this));
  },

  makeSubmission: function(event) {
    event.preventDefault();
    var cardId = null;
    if (!$(event.target).parents().hasClass("list-view")) {
      var el = $(event.target).parents('li').find('a').attr('href')
      cardId = parseInt(el);
    }
    url = "/api/games/" + gameId() + "/cards/" + cardId;
    var posting = $.post(url, { "user_id": userId() });
    posting.done(function( data ) {
      this.parseAjaxResponse(data);
      if ( this.game.round.active ) {
        this.delegateGame();
      }
      else {
        this.delegateRecap();
      }
    }.bind(this));
  },

  getUserGames: function() {
    if (userId() != null) {
      url = "/api/users/" +  userId();
      var posting = $.get(url, { "user_id": userId() } );
      posting.done(function( data ) {
        this.userGamesList = new UserGamesList(data)
        this.delegateUserGames();
      }.bind(this));
    }
  },

  choosePageRefresh: function() {
    url = "/api/games/" + gameId();
    var posting = $.get(url, { "user_id": userId() } );
    posting.done(function( data ) {
      this.parseAjaxResponse(data);
      this.delegateSubmission();
    }.bind(this));
  },

  recapPageRefresh: function(event) {
    // debugger
    var round_num = null;
    if (!$(event.target.parents).hasClass("prev-rounds-list")) {

      var el = $(event.target).parents('.game-round-link')[0];
      round_num = parseInt($(el).attr('href'));
    }
    url = "/api/games/" + gameId() + "/rounds/" + round_num;

    var posting = $.get(url, { "user_id": userId() });
    posting.done(function( data ) {
      this.parseAjaxResponse(data);
      this.delegateRecap();
    }.bind(this));
  },

  bindEvents: function() {
    $("#game-overview .prev-rounds-list").on('click', this.getPreviousRoundRecap.bind(this));
    $('#game .choose-button-container a').on('click', this.delegateSubmission.bind(this));
    $("#game #game-refresh").on('click', this.getCurrentGameState.bind(this));
    $('#choose .listview').on('click', 'li a.card-link', this.makeSubmission.bind(this));
    $('#user-login').on('click', this.loginUser.bind(this));
    $('.user-logout').on('click', this.logoutUser.bind(this));

    $("#game-overview .back-to-user").on('click', function() {

     setTimeout(
      function(){
        $.mobile.changePage("#user");
        location.reload();
      },100
      );

   });
    $("#game .back-to-game-overview").on('click', function() {
      setTimeout(
              function(){
                
                $.mobile.changePage("#game-overview");
                location.reload();
              },100
            );
      });
    $("#recap .back-to-game-overview").on('click', function() { 
      setTimeout(
              function(){
                
                $.mobile.changePage("#game-overview");
                location.reload();
              },100
            );
      })
  },

  bindPageCreates: function() {
    var that = this;
    $("#game-overview").on('pagebeforecreate', this.getGameOverview.bind(this));
    $("#game").on('pagebeforecreate', this.getCurrentGameState.bind(this));
    $("#user").on('pagebeforecreate', function() {
      that.accountManager();
      that.getUserGames(); });
  }
}

// USER
$( document ).delegate("#create-account", "pageinit", function() {
  bindCreateUser( $("#user-create-button"),$("#user-name"),$("#user-password"),$("#user-phone"),$("#user-email") );
});

var bindCreateUser = function($submit, $user_name, $user_password, $user_phone, $user_email) {
  $submit.on("click", function(event) {
    var user_name = $user_name.val();
    var user_password = $user_password.val();
    var user_phone = $user_phone.val();
    var user_email = $user_email.val();
    event.preventDefault();
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
