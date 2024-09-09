require "yaml"

class ImportLayerService < BaseService
  attr_reader :account, :file

  def initialize(account, file)
    @account = account
    @file = file
  end

  def call
    import_file
  end

  protected

  def import_file
    pricing_model = YAML.load_file(file)

    process_pricing_model(pricing_model)
  end

  def process_pricing_model(pricing_model)
    pricing_model["layers"].map do |layer_opts|
      layer = process_layer(layer_opts)
      layer.active!
      layer
    end
  end

  def process_layer(layer_opts)
    layer = @account.layers.create!(name: layer_opts["name"])

    process_plans(layer, layer_opts["plans"])
    process_pricing_tables(layer, layer_opts["pricing_tables"])

    layer
  end

  def process_pricing_tables(layer, pricing_tables_opts)
    pricing_tables_opts.to_a.each do |pricing_table_opts|
      process_pricing_table(layer, pricing_table_opts)
    end
  end

  def process_pricing_table(layer, pricing_table_opts)
    pricing_table = layer.pricing_tables.create!(pricing_table_opts.slice("code", "name"))

    pricing_table_opts["cards"].each do |card_opts|
      process_card(pricing_table, card_opts)
    end
  end

  def process_card(pricing_table, card_opts)
    plan = Plan.find_by(code: card_opts["plan"])

    PricingCard.transaction do
      card = pricing_table.pricing_cards.create!(plan:, **card_opts.slice("name"))

      card_opts["features"].each do |feature_opts|
        card.pricing_card_features.create!(**feature_opts.slice("name"))
      end
    end
  end

  def process_plans(layer, plans_opts)
    plans_opts.to_a.each do |plan_opts|
      process_plan(layer, plan_opts)
    end
  end

  def process_plan(layer, plan_opts)
    Plan.transaction do
      currency = Currency.find(plan_opts["currency"])
      plan_version_id = SecureRandom.uuid
      plan = layer.plans.create!(current_version_id: plan_version_id, currency:, **plan_opts.slice("code", "name", "interval", "interval_count"))
      plan_version = plan.plan_versions.create!(id: plan_version_id)

      plan_opts["prices"].each do |price_opts|
        process_price(plan, price_opts)
      end
    end
  end

  def process_price(plan, price_opts)
    Prices::Flat.create!(plan_version_id: plan.current_version_id, **price_opts.slice("flat_fee"))
  end
end
