lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'burn/version'

Gem::Specification.new do |s|
  s.name          = "burn"
  s.version       = Burn::VERSION
  s.authors       = ["Kei Sawada(@remore)"]
  s.email         = ["k@swd.cc"]
  s.summary       = %q{Burn is a free and open source framework that allows you to create 8-bit flavored application using Ruby DSL.}
  s.description   = s.summary
  s.homepage      = "http://k.swd.cc/burn/"
  s.license       = "GPLv3" 
  s.required_ruby_version = '>= 1.9.1'

  s.files         = %w(Rakefile LICENSE README.md) + Dir.glob("{bin,lib,test}/**/*", File::FNM_DOTMATCH).reject {|f| File.directory?(f) }
  s.bindir        = 'bin'
  s.executables   = ["burn"]
  s.test_files    = s.files.grep(%r{^test\/.*_test.rb})
  s.require_paths = ["lib"]
  
  #s.add_dependency "thor", "~> 0.18.1" # thor must support default_command 
  s.add_dependency "thor"
  
  s.add_development_dependency "rake"
end
