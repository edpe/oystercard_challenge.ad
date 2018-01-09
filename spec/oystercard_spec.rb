require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new(5.00) }
  let (:entry_station) {double :entry_station}

  describe '#top_up' do

    it 'checks if the card has been topped-up' do
      expect { oystercard.top_up 1.00 }.to change { oystercard.balance }.by 1.00
    end

    it 'fails to top up beyond maximum balance' do
      oystercard = Oystercard.new(Oystercard::MAXIMUM_BALANCE)
      expect { oystercard.top_up 1.00 }.to raise_error "cannot top-up, #{oystercard.balance + 1.00} is greater than limit of #{Oystercard::MAXIMUM_BALANCE}"
    end

  end

  describe '#touch_in' do

    it 'refuses to touch in when balance is below minimum journey charge' do
      oystercard = Oystercard.new(0.99)
      expect{ oystercard.touch_in(entry_station) }.to raise_error 'Not enough money on your card'
    end

    it 'expects the card to remember the entry station after touch_in' do
      expect(oystercard.touch_in(entry_station)).to eq entry_station
    end

  end

  describe '#touch_out' do

    it 'touches out successfully' do
      expect(oystercard.touch_out).to eq nil
    end

    it 'should deduct the journey charge from the card on touch_out' do
      expect { oystercard.touch_out}.to change { oystercard.balance }.by (-Oystercard::MINIMUM_FARE)
    end

  end

end
