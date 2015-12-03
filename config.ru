use Rack::Reloader, 0
use Rack::ContentLength
system "clear"

require "./lib/racker"

require File.expand_path("./static_middleware.rb", "middleware")
require File.expand_path("./session_middleware.rb", "middleware")
# use Rack::Static, :urls => ["/stylesheets"], :root => "public"

use Static
use Session

run Racker
