#!/usr/bin/env ruby
# Download NBA 2K26 Top 100 player headshots from the NBA CDN.
# Run: ruby download_headshots.rb
# Images saved to ./headshots/ as firstname_lastname.png
#
# Requirements: gem install nba_api (or just uses net/http from stdlib)

require "net/http"
require "uri"
require "json"
require "fileutils"

TOP_100 = [
  [1,   "Nikola Jokic"],
  [2,   "Shai Gilgeous-Alexander"],
  [3,   "Giannis Antetokounmpo"],
  [4,   "Luka Doncic"],
  [5,   "Victor Wembanyama"],
  [6,   "Anthony Edwards"],
  [7,   "Stephen Curry"],
  [8,   "Donovan Mitchell"],
  [9,   "Jaylen Brown"],
  [10,  "Jayson Tatum"],
  [11,  "Kawhi Leonard"],
  [12,  "Cade Cunningham"],
  [13,  "Jalen Brunson"],
  [14,  "Tyrese Haliburton"],
  [15,  "Devin Booker"],
  [16,  "Tyrese Maxey"],
  [17,  "LeBron James"],
  [18,  "Kevin Durant"],
  [19,  "Anthony Davis"],
  [20,  "Joel Embiid"],
  [21,  "Kyrie Irving"],
  [22,  "Jamal Murray"],
  [23,  "Karl-Anthony Towns"],
  [24,  "James Harden"],
  [25,  "Trae Young"],
  [26,  "Bam Adebayo"],
  [27,  "Chet Holmgren"],
  [28,  "Damian Lillard"],
  [29,  "Jimmy Butler"],
  [30,  "Austin Reaves"],
  [31,  "Deni Avdija"],
  [32,  "Jalen Johnson"],
  [33,  "Ja Morant"],
  [34,  "Jalen Williams"],
  [35,  "Paolo Banchero"],
  [36,  "Evan Mobley"],
  [37,  "Pascal Siakam"],
  [38,  "Alperen Sengun"],
  [39,  "Zion Williamson"],
  [40,  "Franz Wagner"],
  [41,  "Julius Randle"],
  [42,  "Scottie Barnes"],
  [43,  "Lauri Markkanen"],
  [44,  "Jalen Duren"],
  [45,  "Cooper Flagg"],
  [46,  "Keyonte George"],
  [47,  "Jaren Jackson Jr."],
  [48,  "Domantas Sabonis"],
  [49,  "LaMelo Ball"],
  [50,  "Amen Thompson"],
  [51,  "Tyler Herro"],
  [52,  "De'Aaron Fox"],
  [53,  "Brandon Ingram"],
  [54,  "Norman Powell"],
  [55,  "Michael Porter Jr."],
  [56,  "Brandon Miller"],
  [57,  "Trey Murphy III"],
  [58,  "Ivica Zubac"],
  [59,  "Derrick White"],
  [60,  "OG Anunoby"],
  [61,  "Rudy Gobert"],
  [62,  "Jarrett Allen"],
  [63,  "Stephon Castle"],
  [64,  "Josh Giddey"],
  [65,  "Shaedon Sharpe"],
  [66,  "Kon Knueppel"],
  [67,  "Dillon Brooks"],
  [68,  "Darius Garland"],
  [69,  "DeMar DeRozan"],
  [70,  "Kristaps Porzingis"],
  [71,  "Mikal Bridges"],
  [72,  "Desmond Bane"],
  [73,  "Aaron Gordon"],
  [74,  "Immanuel Quickley"],
  [75,  "Alexandre Sarr"],
  [76,  "Donovan Clingan"],
  [77,  "Zach LaVine"],
  [78,  "Dyson Daniels"],
  [79,  "Naz Reid"],
  [80,  "Nikola Vucevic"],
  [81,  "Jalen Suggs"],
  [82,  "Isaiah Hartenstein"],
  [83,  "Jaden McDaniels"],
  [84,  "Walker Kessler"],
  [85,  "Jrue Holiday"],
  [86,  "C.J. McCollum"],
  [87,  "Nickeil Alexander-Walker"],
  [88,  "Peyton Watson"],
  [89,  "Anthony Black"],
  [90,  "Ausar Thompson"],
  [91,  "Grayson Allen"],
  [92,  "Payton Pritchard"],
  [93,  "R.J. Barrett"],
  [94,  "Toumani Camara"],
  [95,  "Josh Hart"],
  [96,  "Paul George"],
  [97,  "Onyeka Okongwu"],
  [98,  "Andrew Nembhard"],
  [99,  "Jerami Grant"],
  [100, "Mark Williams"],
]

# Manual NBA player IDs for names that don't match exactly in the API
MANUAL_IDS = {
  "Nikola Jokic"              => 203999,
  "Luka Doncic"               => 1629029,
  "Kristaps Porzingis"        => 204001,
  "Alexandre Sarr"            => 1641726,
  "Nikola Vucevic"            => 202696,
  "C.J. McCollum"             => 203468,
  "R.J. Barrett"              => 1629628,
  "Jimmy Butler"              => 202710,
  "Kon Knueppel"              => 1642364,
  "Cooper Flagg"              => 1642355,
}

HEADERS = {
  "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
  "Referer"    => "https://www.nba.com/"
}

def to_filename(name)
  name
    .downcase
    .gsub(/['.]/, "")       # remove apostrophes and periods
    .gsub(/\s+/, "_")       # spaces to underscores
    .gsub(/[^a-z0-9_]/, "") # strip anything else
    .gsub(/_+/, "_")        # collapse double underscores
    .then { |s| "#{s}.png" }
end

def fetch_player_ids
  uri = URI("https://stats.nba.com/stats/commonallplayers?LeagueID=00&Season=2024-25&IsOnlyCurrentSeason=0")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.open_timeout = 10
  http.read_timeout = 15

  request = Net::HTTP::Get.new(uri)
  HEADERS.each { |k, v| request[k] = v }
  request["Accept"] = "application/json"
  request["x-nba-stats-origin"] = "stats"
  request["x-nba-stats-token"]  = "true"

  response = http.request(request)
  data     = JSON.parse(response.body)

  result_set = data["resultSets"].first
  headers    = result_set["headers"]
  id_idx     = headers.index("PERSON_ID")
  name_idx   = headers.index("DISPLAY_FIRST_LAST")

  result_set["rowSet"].each_with_object({}) do |row, hash|
    hash[row[name_idx]] = row[id_idx]
  end
end

def download_image(url, filepath)
  uri  = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.open_timeout = 10
  http.read_timeout = 15

  request = Net::HTTP::Get.new(uri)
  HEADERS.each { |k, v| request[k] = v }

  response = http.request(request)
  return nil unless response.code == "200"

  data = response.body.force_encoding("BINARY")
  return nil if data.bytesize < 5_000 # skip tiny placeholder images

  File.binwrite(filepath, data)
  data.bytesize
end

# ── Main ──────────────────────────────────────────────────────────────────────

FileUtils.mkdir_p("headshots")

print "Fetching NBA player IDs... "
name_to_id = fetch_player_ids
puts "#{name_to_id.size} players loaded."

downloaded = 0
failed     = []

TOP_100.each do |rank, name|
  pid = MANUAL_IDS[name] || name_to_id[name]

  # Last-name fuzzy fallback
  if pid.nil?
    last = name.split.last
    matches = name_to_id.select { |n, _| n.split.last == last }
    if matches.size == 1
      pid = matches.values.first
      puts "  Fuzzy match: #{name} -> #{matches.keys.first}"
    end
  end

  if pid.nil?
    failed << "##{rank} #{name} - ID not found"
    next
  end

  filename = to_filename(name)
  filepath = File.join("headshots", filename)

  if File.exist?(filepath)
    puts "  ##{rank.to_s.rjust(3)} #{name} - already exists, skipping"
    downloaded += 1
    next
  end

  url  = "https://cdn.nba.com/headshots/nba/latest/1040x760/#{pid}.png"
  size = download_image(url, filepath)

  if size
    puts "  ##{rank.to_s.rjust(3)} #{name} -> #{filename} (#{size / 1024}KB)"
    downloaded += 1
  else
    failed << "##{rank} #{name} - download failed or placeholder returned"
  end

  sleep 0.15 # be polite to the CDN
end

puts
puts "✅ Downloaded: #{downloaded}/100"
if failed.any?
  puts "❌ Failed (#{failed.size}):"
  failed.each { |f| puts "   #{f}" }
end
