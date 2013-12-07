require 'spec_helper'

describe Todo do
  describe ".validations" do
    it { should validate_presence_of :title }
    it { should ensure_length_of(:title).is_at_most(140) }
  end
end
