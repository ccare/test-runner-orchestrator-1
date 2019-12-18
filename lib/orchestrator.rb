ENV["APP_ENV"] ||= "development"

require 'erb'
require "mandate"
require 'rbczmq'
require 'json'
require 'yaml'
require 'securerandom'
require 'concurrent-ruby'
require 'rest-client'

require "ext/string"
require "ext/nilclass"
require "ext/s3"

require "orchestrator/logger"
require "orchestrator/application"
require "orchestrator/exceptions"
require "orchestrator/language"
require "orchestrator/language_settings"
require "orchestrator/language_processor"
require "orchestrator/queue"
require "orchestrator/spi_client"
require "orchestrator/submission"
require "orchestrator/test_run"
require "orchestrator/test_runner"

%w{
  platform_connection
}.each do |lib|
  lib = ENV["APP_ENV"] == "development" ? "orchestrator/stubs/#{lib}" :
                                          "orchestrator/#{lib}"
  require lib
end

require "orchestrator/http/app"

module Orchestrator
  def self.env
    @env ||= ENV["APP_ENV"]
  end

  def self.application
    @application ||= Orchestrator::Application.start!
  end
end

# Get a new application on this main thread
# before sinatra or anything else kicks in
Orchestrator.application
