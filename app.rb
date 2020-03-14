# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################
require "geocoder"

attractions_table = DB.from(:attractions)
ratings_table = DB.from(:ratings)
users_table = DB.from(:users)

before do
    @current_user = users_table.where(id: session["user_id"]).to_a[0]
end

get "/" do
    puts attractions_table.all
    @attractions = attractions_table.all.to_a
    view "attractions"

end

get "/attractions/:id" do
    @attraction = attractions_table.where(id: params[:id]).to_a[0]
    @ratings = ratings_table.where(attraction_id: @attraction[:id])
    @ratings_count = ratings_table.where(attraction_id: @attraction[:id], worth_it: true).count
    @users_table = users_table
    view "attraction"
end

get "/attractions/:id/ratings/new" do
    @attraction = attractions_table.where(id: params[:id]).to_a[0]
    view "new_rating"
end

get "/attractions/:id/ratings/create" do
    puts params
    results = Geocoder.search(params["location"])
    lat_long = results.first.coordinates
    @attraction = attractions_table.where(id: params["id"]).to_a[0]
    ratings_table.insert(attraction_id: params["id"],
                       user_id: session["user_id"],
                       worth_it: params["Worth the trip?"],
                       comments: params["comments"],
                       location: params["location"])

    view "create_rating"
end

get "/users/new" do
    view "new_user"
end

post "/users/create" do
    puts params
    hashed_password = BCrypt::Password.create(params["password"])
    users_table.insert(name: params["name"], email: params["email"], password: hashed_password)
    view "create_user"
end

get "/logins/new" do
    view "new_login"
end

post "/logins/create" do
    user = users_table.where(email: params["email"]).to_a[0]
    puts BCrypt::Password::new(user[:password])
    if user && BCrypt::Password::new(user[:password]) == params["password"]
        session["user_id"] = user[:id]
        @current_user = user
        view "create_login"
    else
        view "create_login_failed"
    end
end

get "/logout" do
    session["user_id"] = nil
    @current_user = nil
    view "logout"
end
