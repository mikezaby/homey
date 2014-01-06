# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'homey/version'

Gem::Specification.new do |s|
  s.name        = 'homey'
  s.version     = Homey::VERSION
  s.date        = '2014-01-05'

  s.summary     = 'A tool to setup your home enviroment'
  s.description = "Homey is a basic tool for your dotfiles. Homey will setup " \
                  "your symbolic links and run the scripts you want to " \
                  "initialize your enviroment"

  s.authors     = ["Mike Zaby"]
  s.email       = 'mikezaby@gmail.com'
  s.homepage    = 'https://github.com/mikezaby/homey'

  s.executables = %w(homey)
  s.files       = `git ls-files`.split($/)

  s.license     = 'MIT'

  s.add_runtime_dependency 'thor', '~> 0.18', '>= 0.18.1'
  s.add_development_dependency 'pry-byebug', '~> 1.2'
end
