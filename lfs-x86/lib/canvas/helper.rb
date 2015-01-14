module Canvas
  module Helper
    include Rack::Utils

    alias_method :h, :escape_html

    def strip_tags(str, width)
      str.gsub! /<\/?[^>]*>/, ''
      if str.size > width then
        str = str[0, width] + ' ...'
      end
      str
    end

    def production?
      settings.environment == :production
    end

    def ftime(time)
      time = Canvas::Tz.utc_to_local(time) if time.utc?
      time.strftime("%d.%m.%Y %H:%M:%S %z")
    end

    def recent_file_path
      files = file_paths
      path = settings.root + '/files/' + files.first + '.md'
    end

    def file_paths
      files = []
      Dir.glob(settings.root + '/files/*.md') { |file|
        files << File.basename(file, '.md')
      }
      files.sort.reverse
    end

    def convert(raw) # md to html
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML, {
          :tables             => true,
          :fenced_code_blocks => true,
          :strikethrough      => true,
          :no_intra_emphasis  => true
        }
      ).render(raw)
    end
  end
end
