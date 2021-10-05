require "csv"

class ExtractCsvJob < ApplicationJob
  queue_as :default

  before_perform do |job|
    resource = job.arguments[0][:resource]
    resource.status = :processing if resource.on_hold?
    resource.save!
  end

  def perform(params = {})
    resource = params[:resource]
    create_ir(resource) if resource.processing?
    store_contacts(resource) if resource.mapped?
  end

  after_perform do |job|
    resource = job.arguments[0][:resource]
    resource.status = :finished unless resource.needs_mappings? || resource.failed?
    resource.save!
  end

  private

  def create_ir(resource)
    resource.ir = {"records" => []}
    resource.contacts_file.open do |csv|
      parsed = CSV.read(csv.path, headers: true, skip_blanks: true)
      resource.ir["headers"] = parsed.headers.index_with(nil)
      parsed.each do |record|
        (resource.ir["records"]).push(
          record.each_with_object({}) { |(key, val), acc| acc[key] = val }
        )
      end
    end
    resource.status = :needs_mappings
    resource.save!
  end

  def store_contacts(resource)
    failure = false
    resource.ir["records"].each do |record|
      params = record.transform_keys do |key|
        resource.ir["headers"][key]
      end
      params.compact!
      params.delete(nil)
      contact = resource.contacts.build({details: params, user: resource.user})
      failure |= contact.save
    end
    resource.reload
    resource.status = "failed" unless failure
  end
end
