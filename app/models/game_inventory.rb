class GameInventory

  def initialize(user_id)
    @user = User.find(user_id)
    @games = @user.games
    @each_game = []
    populate_eachgame()
  end

  def populate_eachgame()
    games_json = []
    @games.each do |game|
      games_json << GameGetter.new(game.id, @user.id).game_state
    end
    games_json.each do |game|
      puts "*"*50
      p game
    end
  end

end
