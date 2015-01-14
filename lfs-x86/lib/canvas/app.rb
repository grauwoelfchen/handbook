#!/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'
require 'haml'
require 'sass'
require 'uri'
require 'redcarpet'

require  settings.root + '/lib/canvas/helper'

module Canvas
  helpers Canvas::Helper

  configure do
    not_found do
      haml :error
    end
  end

  before do
    @files = file_paths
  end

  get %r{/(layout|style).css} do
    sass :"#{params[:captures].first}", :style => :compact
  end

  get '/sitemap.xml' do
    content_type 'xml'
    haml :sitemap, :layout => false
  end

  get '/rss.xml' do
    content_type 'xml'
    haml :rss, :layout => false
  end

  get '/' do
    path = recent_file_path
    raw = File.read(path)
    @text = convert(raw)
    haml :file
  end

  get '/:file' do
    path = settings.root + '/files/' + params[:file] + '.md'
    halt 404, 'Not found' unless File.exist?(path)
    raw = File.read(path)
    @text = convert(raw)
    haml :file
  end
end
