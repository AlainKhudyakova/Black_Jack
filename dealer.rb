class Dealer < Participant
  def initialize
    super('Dealer')
  end

  def should_hit?
    total_points < 17
  end
end
