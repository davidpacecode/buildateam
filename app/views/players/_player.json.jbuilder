json.extract! player, :id, :overall_rank, :first_name, :last_name, :position, :height, :team, :overall, :three_pt, :dunk, :created_at, :updated_at
json.url player_url(player, format: :json)
