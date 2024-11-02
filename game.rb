class Game
  attr_accessor :player, :dealer, :deck, :pot

  def initialize(player_name)
    @player = Player.new(player_name)
    @dealer = Dealer.new("Dealer")
    @deck = create_deck.shuffle
    @pot = 20 #Ставки по 10 от игрока и дилера
  end

  def create_deck
    ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    suits = ['K+', 'K<3', 'K^', 'K<>']
    deck []

    suits.each do |suit|
      ranks.each do |rank|
        deck << Card.new(rank, suit)
      end
    end
    deck
  end
end
