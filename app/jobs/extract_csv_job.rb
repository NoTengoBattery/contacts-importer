require "csv"

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

  def perform(params = {})
    create_ir(params[:resource])
  end

  private
    # No time to optimize this
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def create_ir(resource)
      # Try to make the save an atomic operation by holding the mid process in memory and writing until it's done
      new_ir = resource.ir || {}
      resource.contacts_file.open do |csv|
        parsed = CSV.read(csv.path, headers: true, skip_blanks: true)
        new_ir[:headers] = parsed.headers.index_with { |_item| nil }
        records = new_ir[:records] || []
        parsed.each do |record|
          record_hash = {}
          record.each do |key, val|
            record_hash[key] = val
          end
          records.push({ data: record_hash })
        end
        new_ir[:records] = records
      end
      resource.ir = new_ir
      resource.save!
    end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
