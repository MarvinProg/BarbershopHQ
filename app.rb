require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, {adapter:"sqlite3", database:"barbershop.db"}

class Client < ActiveRecord::Base
  validates :name, presence: true, length: {minimum: 3}
  validates :phone, presence: true
  validates :datestamp, presence: true
  validates :color, presence: true
end

class Barber < ActiveRecord::Base

end

before do
  @barbers = Barber.all 
end

get '/' do
    #@barbers = Barber.order "created_at desc"
  erb :index 
end

get '/visit' do
    @c = Client.new
    erb :visit
end

post '/visit' do

  @c = Client.new params[:client]
  if @c.save 
    erb "<h2>Спасибо, вы записались!</h2>"
  else
    @error = @c.errors.full_messages.first
    erb :visit
  end

=begin  
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @barber = params[:barber]
  @color = params[:color]

  c = Client.new
  c.name = @username
  c.phone = @phone
  c.datestamp = @datetime
  c.barber = @barber
  c.color = @color
  c.save
=end

  erb "<h2>Спасибо, вы записались! </h2>" 
end

get '/barber/:id' do
  @barber = Barber.find(params[:id])
  erb :barber
end


get '/bookings' do
  @clients = Client.order('created_at DESC')
  erb :bookings
end

get '/client/:id' do
  @client = Client.find(params[:id])
  erb :client
end


configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
