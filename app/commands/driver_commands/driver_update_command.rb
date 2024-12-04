# frozen_string_literal: true

module DriverCommands
  class DriverUpdateCommand
    prepend SimpleCommand

    def initialize(options = {})
      @options = options
    end

    def call
      driver = Driver.find_by(id: @options[:id])
      unless driver
        errors.add(:base, "Driver not found")
        return nil
      end

      driver.update!(@options)
      driver
    end
  end
end
