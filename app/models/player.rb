class Player < ApplicationRecord

  # strip or swap out characters that break file names...
  def headshot_file_name
    "#{first_name.gsub(".","").gsub("'","").downcase}_#{last_name.gsub(".","").gsub(" ","_").downcase}.png"
  end

  def self.how_many_play(posn)
    search_term = "%#{posn}%"
    self.where("position LIKE ?", search_term).count
  end

  def self.who_play(posn)
    search_term = "%#{posn}%"
    self.where("position LIKE ?", search_term)
  end
end
