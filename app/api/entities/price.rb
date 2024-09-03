module Entities
  class Price < BaseEntity
    expose :id
    expose :kind

    with_options(format_with: :money) do
      expose :flat_fee
    end
  end
end
