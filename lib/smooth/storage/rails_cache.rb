# Even Simpler.
class Smooth::Storage::RailsCache < Smooth::Storage
  def restore
    Rails.cache.fetch(key, {})
  end

  def persist
    Rails.cache.write key, self.storage
  end
end
