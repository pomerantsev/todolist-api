require 'spec_helper'

describe Todo do
  describe ".validations" do
    it { should validate_presence_of :title }
  end
end
