require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#shipped?' do
    it { is_expected.to respond_to(:shipped?) }

    context 'when a shipped date exists' do
      before { subject.update(shipped_at: Time.now) }
      it { is_expected.to be_shipped }
    end

    context 'when no shipped date is present' do
      it { is_expected.to_not be_shipped }
    end
  end

  describe '#expedited?' do
    it { is_expected.to respond_to(:expedited?) }

    context 'when expedite is true' do
      before { subject.update(expedite: true) }
      it { is_expected.to be_expedited }
    end

    context 'when expedite is false' do
      before { subject.update(expedite: false) }
      it { is_expected.to_not be_expedited }
    end
  end

  describe '#settings' do
    it { is_expected.to respond_to(:settings) }

    # context 'when expedite is present' do
    #   before { subject.settings(expedite: true) }
    #   it { is_expected.to be_expedited }
    # end

    context 'when returns is present' do
      before { subject.settings(returns: true) }
      it { is_expected.to be_returnable }
    end

    context 'when warehouse is present' do
      before { subject.settings(warehouse: true) }
      it { is_expected.to be_warehoused }
    end
  end
end
