lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'convert_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'convert_api187'
  spec.version       = ConvertApi::VERSION
  spec.authors       = ['Tomas Rutkauskas', 'Ian Heggie']
  spec.email         = ['ian@heggie.biz']

  spec.summary       = %q{ConvertAPI client library backported to ruby 1.8.7}
  spec.description   = %q{Convert various files like MS Word, Excel, PowerPoint, Images to PDF and Images. Create PDF and Images from url and raw HTML. Extract and create PowerPoint presentation from PDF. Merge, Encrypt, Split, Repair and Decrypt PDF files. All supported files conversions and manipulations can be found at https://www.convertapi.com/doc/supported-formats [Backport to ruby 1.8.7]}
  spec.homepage      = 'https://github.com/ianheggie/convertapi-ruby'
  spec.license       = 'MIT'

  spec.required_ruby_version = '~> 1.8.7'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|examples)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'json', '~> 1.7.7'
end
