class Participant
  attr_accessor :name, :bank, :hand

  def initialize(name)
    @name = name
    @bank = 100
    @hand = []
  end

  def add_card(card)
    @hand << card
  end

  def clear_hand
    @hand.clear
  end

  def place_bet(amount)
    if amount <= @bank
      @bank -= amount
      puts "#{@name} placed a bet of #{amount}. Remaining bank: #{@bank}."
      true
    else
      puts 'Not enough money to bet.'
      false
    end
  end

  def total_points
    total = 0
    ace_count = 0
    
    @hand.each do |card|
      total += card.value
      ace_count += 1 if card.rank == 'A'
    end
  
    # Если сумма больше 21 и есть тузы, уменьшаем их значение
    while total > 21 && ace_count > 0
      total -= 10
      ace_count -= 1
    end

    total
  end

  def show_bank
    puts "#{name}'s current bank: #{@bank}"
  end
end