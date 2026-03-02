class Player < ApplicationRecord

  # strip or swap out characters that break file names...
  def headshot_file_name
    "#{first_name.gsub(".","").gsub("'","").downcase}_#{last_name.gsub(".","").gsub(" ","_").downcase}.png"
  end
end
