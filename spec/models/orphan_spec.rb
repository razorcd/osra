require 'rails_helper'

describe Orphan, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :orphan).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :father_name }
  it { is_expected.to_not allow_value(nil).for(:father_is_martyr) }

  it { is_expected.to validate_presence_of :father_date_of_death }
  it { is_expected.to allow_value(Date.today - 5, Date.current).for(:father_date_of_death) }
  it { is_expected.to_not allow_value(Date.today + 5).for(:father_date_of_death) }
  it { is_expected.to_not allow_value(7, 'yes', true).for(:father_date_of_death) }

  it { is_expected.to validate_presence_of :mother_name }
  it { is_expected.to_not allow_value(nil).for(:mother_alive) }

  it { is_expected.to allow_value(Date.today - 5, Date.current).for(:date_of_birth) }
  it { is_expected.to_not allow_value(Date.today + 5).for(:date_of_birth) }
  it { is_expected.to_not allow_value(7, 'yes', true).for(:date_of_birth) }

  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to ensure_inclusion_of(:gender).in_array %w(Male Female) }

  it { is_expected.to validate_presence_of :contact_number }

  it { is_expected.to_not allow_value(nil).for(:sponsored_by_another_org) }

  it { is_expected.to validate_numericality_of(:minor_siblings_count).only_integer.is_greater_than_or_equal_to(0) }

  it { is_expected.to validate_presence_of :original_address }

  it { is_expected.to validate_presence_of :current_address }

  it { is_expected.to belong_to(:original_address).class_name 'Address' }
  it { is_expected.to belong_to(:current_address).class_name 'Address' }
end
