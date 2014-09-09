class Blackcard < ActiveRecord::Base
  has_one :round

  validates_presence_of :content
end
