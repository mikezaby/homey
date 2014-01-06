module Homey
  class Tasks < Thor
    desc "dotfiles", "Fetching your dotfiles from github"
    method_option :path, type: :string
    method_option :force, aliases: "-f", type: :boolean
    method_option :local, aliases: "-l", type: :boolean
    def dotfiles(repo)
      path = prepare_paths(options.fetch("path", "~/.dotfiles")).first
      if !options[:local]
        FileUtils.rm_rf(path) if options["force"]
        command = "git clone git@github.com:#{repo}.git #{path}"
        system command
      end
      File.open("#{ENV['HOME']}/.homey", 'w') { |f| f.write(path) }
    end

    desc "create_symlinks", "Creating the sym links that you have set in home.yml"
    method_option :flavor, type: :string
    method_option :force, aliases: "-f", type: :boolean
    def create_symlinks
      opts = { flavor: options[:flavor], flavorized_attributes: %w(target) }
      symlinks = Flavorizer::flavorize_group(home_file["sym_links"], opts)
      symlinks.each do |sym|
        target, link = prepare_paths(sym['target'], sym['link'])
        FileUtils.rm_rf(link) if options[:force]
        File.symlink target, link
      end
    end

    desc "setup", "Run the initialize commands that you want"
    def setup
      home_file["commands"].each { |command| system command }
    end

    private

    def dotfiles_path
      @dotfiles_path ||= File.open("#{ENV['HOME']}/.homey", 'rb').read
    end

    def home_file
      @home_file ||= begin
        path = File.join dotfiles_path, "home.yml"
        home = YAML.load_file(path)
      end
    end

    def prepare_paths(*paths)
      absolutize_paths(*replace_home_char(*paths))
    end

    def absolutize_paths(*paths)
      paths.map { |path| Pathname.new(path).expand_path(dotfiles_path) }
    end

    def replace_home_char(*strings)
      strings.map { |string| string.sub(/^~\//, "#{ENV['HOME']}/") }
    end
  end
end
