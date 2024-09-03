module Entities
  class Plan < BaseEntity
    expose :id
    expose :code
    expose :name
    expose :interval
    expose :interval_count
    expose :currency_id, as: :currency
    expose :prices, using: Entities::Price
  end
end
