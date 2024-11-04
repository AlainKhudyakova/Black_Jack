class Dealer < Participant

  def should_hit?
    total_points < 17
  end
end
