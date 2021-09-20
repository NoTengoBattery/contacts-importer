require "csv"

class ExtractCsvJob < ApplicationJob
  queue_as :default

  before_perform do |job|
    resource = job.arguments[0][:resource]
    resource.status = "processing" if resource.on_hold?
    resource.save!
  end

  after_perform do |job|
    resource = job.arguments[0][:resource]
    resource.status = "finished" unless resource.needs_mappings? || resource.failed?
    # resource.save!
  end

  def perform(params = {})
    resource = params[:resource]
    create_ir(resource) if resource.processing?
    store_contacts(resource) if resource.mapped?
  end

  private

  # No time to optimize this
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def create_ir(resource)
    new_ir = resource.ir || {}
    resource.contacts_file.open do |csv|
      parsed = CSV.read(csv.path, headers: true, skip_blanks: true)
      new_ir[:headers] = parsed.headers.index_with { |_item| nil }
      records = new_ir[:records] || []
      parsed.each do |record|
        records.push(record.each_with_object({}) do |(key, val), acc|
          acc[key] = val
        end)
      end
      new_ir[:records] = records
    end
    resource.ir = new_ir
    resource.status = "needs_mappings"
    resource.save!
  end

  def store_contacts(resource)
    resource.ir["records"].each do |record|
      params = record.transform_keys do |key|
        resource.ir["headers"][key]
      end
      contact = resource.contacts.build({details: params})
      contact.save!
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
