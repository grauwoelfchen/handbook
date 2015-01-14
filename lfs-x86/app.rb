#!/usr/bin/env ruby
# encoding: utf-8

require 'tzinfo'
require 'ostruct'

require  settings.root + '/lib/canvas/app'

module Canvas

  configure :development do |config|
    require 'sinatra/reloader'
    config.also_reload(
      '*.rb',
      'lib/canvas/*.rb'
    )
    after do
      p response.status
    end
  end

  configure :production do
    require 'rack/cache'
    use Rack::Cache
    error do
      'Error ;-('
    end
  end

  configure do
    ENV['APP_URL'] = 'http://localhost:9292/' unless ENV.has_key? 'APP_URL'
    ENV['TZ']      = 'Asia/Tokyo' unless ENV.has_key? 'TZ'
    Tz = TZInfo::Timezone.get(ENV['TZ'])
    Env = OpenStruct.new(
      :url_base  => ENV['APP_URL'],
      :title     => '=lib-canvas/notes-9999 ~devel',
      :sub_title => 'Let\'s notes :-)',
      :author    => 'Yasuhiro Asaka',
      :note      => 'This is notes.',
    )
  end
end
