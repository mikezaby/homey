module Homey
  class Tasks < Thor
    include PathHelpers

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
  end
end
