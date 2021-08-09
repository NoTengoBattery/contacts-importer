class ExtractCsvJob < ApplicationJob
  queue_as :default

  before_perform do |job|
    resource = job.arguments[0][:resource]
    resource.status = "processing"
    resource.save!
  end

  after_perform do |job|
    resource = job.arguments[0][:resource]
    resource.status = "finished"
    resource.save!
  end

  def perform(_params = {})
    sleep 5.seconds
  end
end
