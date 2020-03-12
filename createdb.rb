# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :attractions do
  primary_key :id
  String :title
  String :description, text: true
  String :current_conditions
  String :news
end
DB.create_table! :ratings do
  primary_key :id
  foreign_key :attraction_id
  Boolean :worth_it
  String :name
  String :email
  String :comments, text: true
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

# Insert initial (seed) data
attractions_table = DB.from(:attractions)

attractions_table.insert(title: "Old Faithful", 
                    description: "The world's most renowned geyser is a must-see for every Yellowstone visitor. Although it isn't the largest geyser in the world, Old Faithful's eruptions are definitely awe-inspiring, averaging around 130 feet high. Like its name suggests, you can count on Old Faithful erupting approximately every hour and a half (the nearby visitors center can provide you with a more accurate schedule). There are several ways to see Old Faithful's power: You can join the hordes of tourists who gather around the perimeter or find a less hectic spot in the nearby Old Faithful Inn's dining room. ",
                    current_conditions: "Sunny, 70 degrees and clear skies",
                    news: "Today's geyser eruption schedule: 8:49AM, 12:15PM, 3:45PM, 7:10PM")

attractions_table.insert(title: "Yellowstone Lake", 
                    description: "Sitting in the heart of Yellowstone's West Thumb area is Yellowstone Lake, the park's largest body of water and the largest freshwater lake above 7,000 feet in North America. First visited by Lewis and Clark's scout, John Colter, in the early 1800s, Yellowstone Lake has since become a popular destination among anglers and boaters. During the winter, many animals (think: bison and grizzly bears) trek to the more shallow areas of the lake's southern shores, where the water doesn't freeze due to the geothermic activity that takes place beneath the surface.",
                    current_conditions: "Sunny, 72 degrees and clear skies",
                    news: "Grizzly bear advisory, bear sightings yesterday on south rim trail")

attractions_table.insert(title: "Grand Prismatic Spring", 
                    description: "The Midway Geyser Basin's Grand Prismatic Spring is the largest hot spring in the United States, approximately 370 feet in size and around 121 feet deep. But its rainbow waters are what really make it fascinating: While the center of the pool's cerulean hue is pretty characteristic, the deep reds, bright yellows and fiery oranges encircling the edges are not. These colors are caused by pigmented thermophilic bacteria that thrive on the rich minerals produced by the geothermic activity.",
                    current_conditions: "Sunny, 71 degrees and clear skies",
                    news: "Trail is currently under construction but will remain open between the hours of 9AM and 3PM")



