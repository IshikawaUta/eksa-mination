# eksa-mination.gemspec

Gem::Specification.new do |s|
  s.name        = 'eksa-mination'
  s.version     = '1.0.0'
  s.summary     = "A robust and lightweight Ruby testing framework inspired by RSpec."
  s.description = "Eksa-Mination provides a familiar DSL, comprehensive mocking/stubbing, and rich reporting tools in a lightweight package."
  s.authors     = ["IshikawaUta"]
  s.email       = ["komikers09@gmail.com"]
  s.license     = 'MIT'

  s.files       = Dir["lib/**/*.rb", "bin/*", "README.md", "LICENSE", ".eksa-mination"]
  s.executables << 'eksa-mination'
  s.require_paths = ["lib"]
end