class Dealer
  attr_accessor :hand, :name, :bank

  def initialize(name)
    @name = name
    @hand = []
    @bank = 100
  end

  def add_card(card)
    hand << card
  end

  def place_bet(amount)
    if amount <= @bank
      @bank -= amount
    else
      puts 'Not enough money to bet.'
      nil
    end
  end

  def total_points
    total = 0
    ace_count = 0

    @hand.each do |card|
      if card.rank == 'A'
        ace_count += 1
        total += 1
      else
        total += card.value
      end
    end
    ace_count.times do
      total += 10 if total + 10 <= 21
    end
    total
  end

  def should_hit?
    total_points < 17
  end
end
