class Team < ApplicationRecord

  belongs_to :pg, class_name: "Player", foreign_key: :pg_id, optional: true
  belongs_to :sg, class_name: "Player", foreign_key: :sg_id, optional: true
  belongs_to :sf, class_name: "Player", foreign_key: :sf_id, optional: true
  belongs_to :pf, class_name: "Player", foreign_key: :pf_id, optional: true
  belongs_to :c,  class_name: "Player", foreign_key: :c_id,  optional: true

  def open_spots_left

    open_spots = 0

    ["pg", "sg", "sf", "pf", "c"].each do |player|
      open_spots += 1 if self.send("#{player}_id") == 0
    end
    open_spots
  end

  def players
    players = []
    ["pg", "sg", "sf", "pf", "c"].each do |player|
      players << self.send("#{player}_id") unless self.send("#{player}_id") == 0
    end
    players
  end

  def average_rating
    if self.players.count != 5
      0.0
    else
      total = 0.0
      self.players.each do |player|
        total += Player.find(player).overall.to_f
      end
      total / self.players.count.to_f
    end
  end
end
