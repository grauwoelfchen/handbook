require 'sinatra'

root_dir   = File.expand_path(File.dirname(__FILE__))
canvas_dir = root_dir + '/lib/canvas'
{
  :root          => root_dir,
  :canvas        => canvas_dir,
  :pubilc_folder => File.join(root_dir,   'public'),
  :views         => File.join(canvas_dir, 'views'),
  :run           => false,
}.each_pair do |key, val|
  Sinatra::Base.set(key, val)
end

require root_dir + '/app'

run Sinatra::Application

