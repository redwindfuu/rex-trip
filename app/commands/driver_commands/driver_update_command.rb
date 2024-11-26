# frozen_string_literal: true

module DriverCommands
  class DriverUpdateCommand
    prepend SimpleCommand

    def initialize(options = {})
      @options = options
    end

    def call
      driver = Driver.find_by(id: @options[:id])
      raise Errors::NotFound, 'Driver not found' unless driver

      driver.update!(@options)
      driver

    end
  end
end
