module DummyTime
  class DummyTime
    include Mongoid::Document

    field :worktime, type: TimeField.new(format: 'HH:MM')
  end
end