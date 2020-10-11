# frozen_string_literal: true

require 'rexml/document'
require 'rspec/core/formatters/base_formatter'

module RSpec
  # Format the results of rspec into a checkstyle format.
  # See reporter implementation for details.
  # https://github.com/rspec/rspec-core/blob/main/lib/rspec/core/reporter.rb
  class CheckstyleFormatter < RSpec::Core::Formatters::BaseFormatter
    RSpec::Core::Formatters.register self,
                                     :example_failed,
                                     :close

    def initialize(output)
      super(output)
      @xml_document = REXML::Document.new
      @xml_document << REXML::XMLDecl.new
      @checkstyle = REXML::Element.new('checkstyle', @xml_document)
      @failed_notifications_group_by_filename = {}
    end

    def example_failed(notification)
      unless @failed_notifications_group_by_filename.key?(notification.example.file_path)
        @failed_notifications_group_by_filename[notification.example.file_path] = []
      end
      @failed_notifications_group_by_filename[notification.example.file_path] << notification
    end

    def close(_null_notification)
      @failed_notifications_group_by_filename.each do |filename, failed_notifications|
        file_element = REXML::Element.new('file', @checkstyle)
        file_element.attributes['name'] = filename
        append_errors(file_element, failed_notifications)
      end
      @xml_document.write(@output, 2)
    end

    private

    def append_errors(file_element, failed_notifications)
      failed_notifications.each do |notification|
        error_element = REXML::Element.new('error', file_element)
        # How do I extract the column numbers? Set it to 1 for now.
        error_element.add_attributes({
                                       'line' => notification.example.location.split(':').last,
                                       'column' => 1,
                                       'severity' => 'error',
                                       'message' => build_message(notification),
                                       'source' => notification.description
                                     })
      end
    end

    def build_message(notification)
      notification.message_lines.map { |s| remove_non_printables(s) }.join("\n") +
        "\n\n" +
        notification.formatted_backtrace.map { |s| remove_non_printables(s) }.join("\n")
    end

    def remove_non_printables(str)
      # XML is very sensitive.
      str.gsub(/[^[:print:]]/, '')
    end
  end
end
