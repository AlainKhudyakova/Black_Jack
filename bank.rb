class Bank
  attr_accessor :player_balance, :dealer_balance

  def initialize
    @player_balance = 100
    @dealer_balance = 100
  end

  def add_player_funds(amount)
    @player_balance += amount
  end

  def add_dealer_funds(amount)
    @dealer_balance += amount
  end

  def deduct_player_funds(amount)
    @player_balance -= amount if @player_balance >= amount
  end

  def deduct_dealer_funds(amount)
    @dealer_balance -= amount if @dealer_balance >= amount
  end

  # Метод для отображения текущего состояния банков
  def display_balances
    puts "Current balances: Player - #{@player_balance}, Dealer - #{@dealer_balance}"
  end

  def place_auto_bet(bet_amount)
    if @player_balance >= bet_amount && @dealer_balance >= bet_amount
      deduct_player_funds(bet_amount)
      deduct_dealer_funds(bet_amount)
      puts "Player and Dealer both placed bets of #{bet_amount}."
    else
      puts 'Not enough funds to place bets!'
    end
  end
end
