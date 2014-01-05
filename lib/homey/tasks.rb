module Homey
  class Tasks < Thor
    desc "create_symlinks", "Creating the sym links that you have set in home.yml"
    method_option :flavor, type: :string
    method_option :force, aliases: "-f", type: :boolean
    def create_symlinks
      opts = { flavor: options[:flavor], flavorized_attributes: %w(target) }
      symlinks = Flavorizer::flavorize_group(home_file["sym_links"], opts)
      symlinks.each do |sym|
        paths = replace_home_char(sym['target'], sym['link'])
        target, link = absolutize_paths(*paths)
        FileUtils.rm_rf(link) if options[:force]
        File.symlink target, link
      end
    end

    desc "setup", "Run the initialize commands that you want"
    def setup
      home_file["commands"].each { |command| system command }
    end

    private

    def home_file
      @home_file ||= begin
        home = YAML.load_file('home.yml')
      end
    end

    def absolutize_paths(*paths)
      paths.map { |path| Pathname.new(path).expand_path }
    end

    def replace_home_char(*strings)
      new_strings = strings.map { |string| string.sub(/^~\//, "#{ENV['HOME']}/") }
      new_strings.one? ? new_strings.first : new_strings
    end
  end
end