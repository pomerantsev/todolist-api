require 'spec_helper'

describe Todo do
  describe ".validations" do
    it { should validate_presence_of :title }
    it { should ensure_length_of(:title).is_at_most(140) }

    it "doesn't allow nil in 'completed'" do
      # ensure_inclusion_of doesn't work for boolean values:
      # https://github.com/thoughtbot/shoulda-matchers/issues/179
      expect(build(:todo, completed: true)).to be_valid
      expect(build(:todo, completed: false)).to be_valid
      expect(build(:todo, completed: nil)).to_not be_valid
    end

    it { should validate_presence_of :priority }
    it { should ensure_inclusion_of(:priority).in_range(1..3) }
  end
end
