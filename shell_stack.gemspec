# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shell_stack/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mitoma Ryo"]
  gem.email         = ["mutetheradio@gmail.com"]
  gem.description   = %q{simple stack for shellscript}
  gem.summary       = %q{simple stack for shellscript}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "shell_stack"
  gem.require_paths = ["lib"]
  gem.version       = Shell::Stack::VERSION
end
