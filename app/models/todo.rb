class Todo < ActiveRecord::Base
  validates :title, presence: true,
                    length: { maximum: 140 }
  validates :completed, inclusion: { in: [true, false] }
  validates :priority, presence: true,
                       inclusion: { in: 1..3 }
end
