module TeamsHelper

  def card_appearance (new_team, team, pos)
    if !(new_team || team.send("#{pos.downcase}_id") == 0)
      "filled-outlined"
    else
      "outlined"
    end
  end
end
