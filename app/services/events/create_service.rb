class Events::CreateService
  def initialize(layer, name:, object:)
    @layer = layer
    @name = name
    @object = object
  end

  def call
    @layer.events.create!(event_attrs)
  end

  def event_attrs
    data = entity_klass.represent(@object).as_json
    {
      name: @name,
      data: JSON.pretty_generate(data),
      object_type: @object.object_type,
    }
  end

  def entity_klass
    case @object
    when Customer
      Entities::Customer
    when Invoice
      Entities::Invoice
    when Plan
      Entities::Plan
    when Subscription
      Entities::Subscription
    end
  end
end
