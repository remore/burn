Encoding.default_external = 'UTF-8'
['..', '../lib'].each do |path|
  $LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), path))
end

require 'test/unit'
require 'burn'

