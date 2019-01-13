require 'rails_helper'

RSpec.describe Widget, type: :model do
  # TODO: Replace these with respond_to? so the tests fail
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:msrp) }
  it { is_expected.to respond_to{:name_with_msrp} }
end
