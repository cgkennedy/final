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
  String :image
  String :current_conditions
  String :news
  String :lat
  String :long
end
DB.create_table! :ratings do
  primary_key :id
  foreign_key :attraction_id
  foreign_key :user_id
  Boolean :worth_it
  String :name
  String :email
  String :comments, text: true
  String :location

end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

# Insert initial (seed) data
attractions_table = DB.from(:attractions)

attractions_table.insert(title: "Yellowstone National Park", 
                    description: "Yellowstone National Park is a nearly 3,500-sq.-mile wilderness recreation area atop a volcanic hot spot. Yellowstone features dramatic canyons, alpine rivers, lush forests, hot springs and gushing geysers, including its most famous, Old Faithful. It's also home to hundreds of animal species, including bears, wolves, bison, elk and antelope.",
                    image: "https://www.worldatlas.com/r/w963-h562-c963x562/upload/f1/a7/5e/shutterstock-677567317.jpg",
                    current_conditions: "Sunny, 70 degrees and clear skies",
                    news: "Today's Old Faithful Geyser eruption schedule: 8:49AM, 12:15PM, 3:45PM, 7:10PM",
                    lat: 44.428,
                    long: 110.588)

attractions_table.insert(title: "Grand Canyon National Park",
                    description: "Grand Canyon National Park, in Arizona, is home to much of the immense Grand Canyon, with its layered bands of red rock revealing millions of years of geological history. Viewpoints include Mather Point, Yavapai Observation Station and architect Mary Colter’s Lookout Studio and her Desert View Watchtower.",
                    image: "https://www.nps.gov/common/uploads/banner_image/imr/homepage/99556161-1DD8-B71B-0B896E4D786C6B47.jpg",
                    current_conditions: "Sunny, 72 degrees and clear skies",
                    news: "Mountain Lion advisory, sightings yesterday afternoon on south rim trail",
                    lat: 44.428,
                    long: 110.588)

attractions_table.insert(title: "Yosemite National Park", 
                    description: "Yosemite National Park is in California’s Sierra Nevada mountains. It’s famed for its giant, ancient sequoia trees, and for Tunnel View, the iconic vista of towering Bridalveil Fall and the granite cliffs of El Capitan and Half Dome.",
                    image: "https://www.nationalgeographic.com/content/dam/expeditions/destinations/north-america/private/Yosemite/Hero-Yosemite.ngsversion.1524840074980.adapt.1900.1.jpg",
                    current_conditions: "Sunny, 71 degrees and clear skies",
                    news: "Vernal Falls trail is currently under construction but will remain open between the hours of 9AM and 3PM",
                    lat: 44.428,
                    long: 110.588)




