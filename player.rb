class Player
  attr_accessor :name, :bank, :hand

  def initialize(name)
    @name = name
    @bank = 100
    @hand = []
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

    ace_count.items do
      total += 10 if total + 10 <= 21
    end

    total
  end

  def add_card(card)
    @hand << card
  end

  def place_bet(amount)
    @bank -= amount
  end
end