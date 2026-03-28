require_relative 'eksa-mination/dsl'
require_relative 'eksa-mination/matchers'
require_relative 'eksa-mination/formatters/progress'
require_relative 'eksa-mination/formatters/documentation'
require_relative 'eksa-mination/formatters/json'
require_relative 'eksa-mination/formatters/html'
require_relative 'eksa-mination/runner'
require_relative 'eksa-mination/mocks'
require_relative 'eksa-mination/cli'

module EksaMination
  VERSION = "1.0.0"

  class << self
    attr_accessor :reporter
  end

  self.reporter = Formatters::Progress.new

  def self.run(options = {})
    Runner.new(groups, reporter, options).run
  end
end
