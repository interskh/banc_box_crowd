require 'faraday'
require 'faraday_middleware'

files = [
  'id', 'api', 'config', 'connection', 'error'
]

files.each do |file|
  require File.join(File.dirname(__FILE__), 'banc_box_crowd', file)
end

module BancBoxCrowd

  extend BancBoxCrowd::Api

  def self.configure
    yield Config
    Config
  end

  def self.connection
    @connection ||= BancBoxCrowd::Connection.new
  end
end