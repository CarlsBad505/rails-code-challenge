class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :line_items

  def expedited?
    expedite
  end

  def returnable?
    @returns
  end

  def settings(opts = {expedite: nil})
    @expedite = opts[:expedite].presence
    @returns = opts[:returns].presence
    @warehouse = opts[:warehouse].presence
  end

  def shipped?
    shipped_at.present?
  end

  def warehoused?
    @warehouse
  end
end
