module Entities
  class BaseEntity < Grape::Entity
    format_with(:timestamp) do |time|
      time ? time.to_i : time
    end

    format_with(:money) do |amount|
      amount
    end
  end
end
