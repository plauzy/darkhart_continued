class UserGetter
  def initialize(user_id = nil)
    @user_id = user_id
  end

  def list
    if User.find_by_id(@user_id)
      users = User.all.select { |u| u != User.find(@user_id) }
    else
      users = User.all
    end
      return parse(users)
  end

  def parse(users)
    users.map do |u|
      { user_id: u.id,
        user_name: u.name,
        user_email: u.email }
    end
  end
end
