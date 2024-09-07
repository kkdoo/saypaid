module Entities
  class Invoice < BaseEntity
    expose :id
    expose :status
    expose :currency_id, as: :currency
    expose :line_items, using: Entities::LineItem

    with_options(format_with: :timestamp) do
      expose :due_date
    end

    with_options(format_with: :timestamp) do
      expose :total
    end
  end
end
