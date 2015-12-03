require "securerandom"

class Session

  @@session = {}

  def initialize(nnext)
    @nnext = nnext
  end

  def call(env)
    request = Rack::Request.new(env)
    token = request.cookies["AUTH_TOKEN"]
    if token && @@session[token]
      @@session[token]["counter"] = @@session[token]["counter"] + 1
      env['session_counter'] = @@session[token]["counter"]
      env['last_visit'] = @@session[token]["visit_time"]
      @@session[token]["visit_time"] = Time.now.strftime("%d/%m/%Y %H:%M:%S").to_s
      @nnext.call(env)
    else
      token = create_key
      time = Time.now.strftime("%d/%m/%Y %H:%M:%S").to_s
      @@session[token] = { "counter" => 1, "visit_time" =>  time }
      status, headers, body = @nnext.call(env)
      [status, headers.merge({"Set-Cookie" => "AUTH_TOKEN="+token+"; Path=/;"}), body]
    end
  end

  private
  def create_key(len=10)
    SecureRandom.hex(len)
  end
end
