require "layouts/application_layout_helper"
require "styles/form_helper"
require "styles/flash_helper"
require "validations/form_helper"

module ApplicationHelper
  def resource_attribute_name(res, name, kase = :humanize)
    res.class.human_attribute_name(name).send(kase)
  end

  def locale_link(name, id, params = {})
    params[:method] = :patch
    button_to name, site_locale_path(id), params
  end

  def dom_uid(*thing)
    cache_key = CacheKey.gen!(thing)
    Rails.cache.fetch(cache_key) do
      "I#{Base64.urlsafe_encode64(Digest::SHA256.digest(cache_key), padding: false)}"
    end
  end
end
