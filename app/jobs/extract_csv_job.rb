class ExtractCsvJob < ApplicationJob
  queue_as :default

  def perform(params = {}); end
end
