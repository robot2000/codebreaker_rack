require "erb"
require_relative "app.rb"

class Racker
  def self.call(env)
    new(env).response.finish
  end
   
  def initialize(env)
    @request = Rack::Request.new(env)
    @application = App.new(game_file)
  end
   
  def response
    case @request.path
    when "/" then
      Rack::Response.new do |response|
        response.set_cookie("game_file", game_file)
        response.write(render("index.html.erb"))
      end
    when "/check" then
      @application.check(@request.params['suspect'])
      Rack::Response.new do |response|
        response.set_cookie("game_file", game_file)
        response.redirect('/')
      end
    when "/save" then
      @application.save(@request.params['name'])
      Rack::Response.new do |response|
        response.set_cookie("game_file", '')
        response.redirect('/')
      end
    when "/hint" then
      @application.hint
      Rack::Response.new do |response|
        response.redirect('/')
      end
    when "/start_new" then
      @application.hint
      Rack::Response.new do |response|
        response.set_cookie("game_file", '')
        response.redirect('/')
      end
    else
      Rack::Response.new("Not Found", 404)
    end
  end
   
  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def game_file
    if @request.cookies["game_file"].to_s.empty?
      SecureRandom.hex
    else
      @request.cookies["game_file"]
    end
  end
end
