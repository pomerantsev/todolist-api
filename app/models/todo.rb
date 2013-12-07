class Todo < ActiveRecord::Base
  validates :title, presence: true,
                    length: { maximum: 140 }
end
