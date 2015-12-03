class Static

  @@public_folder = "public/"

  def initialize(nnext)
    @nnext = nnext
  end

  def read_file(file_name, type)
    begin
      file = File.open(@@public_folder + file_name, "r")
      data = file.read
      file.close
      [200, {'Content-Type' => type}, [data]]
    rescue
      [401, {'Content-Type' => 'text/html'}, ["No such file"]]
    end
  end

  def call(env)
    name = env['PATH_INFO']
    case name.to_s
    when /(\/\w+)*.html$/
      read_file(name, "text/html");
    when /(\/\w+)*.js$/
      read_file(name, "application/x-javascript");
    when /(\/\w+)*.css$/
      read_file(name, "text/css");
    when /(\/\w+)*.img$/
      read_file(name, "image/jpeg");
    when /(\/\w+)*.ico$/
      read_file(name, "image/jpeg");
    else
      @nnext.call(env)
    end
  end
end
