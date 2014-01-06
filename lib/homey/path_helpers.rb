module Homey
  module PathHelpers
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
