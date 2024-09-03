module Entities
  class Customer < BaseEntity
    expose :id
    expose :email
    expose :name

    with_options(format_with: :timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end
