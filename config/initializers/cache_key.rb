class CacheKey
  def self.file_digest!(file_path)
    rel = Pathname.new(file_path).relative_path_from(Rails.root)
    Rails.cache.fetch([rel, File.mtime(rel)]) do
      key = "#{rel}:#{Base64.urlsafe_encode64(Digest::SHA256.file(rel).digest, padding: false)}"
      Rails.logger.info { "CacheKey: Refreshed key due to file digest mismatch: \"#{key}\"" }
      key
    end
  end

  def self.gen!(*args)
    kaller = caller_locations(1..1).first
    file_key = CacheKey.file_digest!(kaller.absolute_path)
    cache_key = "#{file_key}##{kaller.label}?#{
      Base64.urlsafe_encode64(
        Digest::SHA256.digest(Marshal.dump(args.sort)),
        padding: false
      )
    }"
    Rails.logger.debug { "CacheKey: Generated: \"#{cache_key}\"" }
    cache_key
  end
end
