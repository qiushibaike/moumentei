# -*- encoding : utf-8 -*-
module CacheControlMethods
  def must_revalidate
    cc = response.headers['Cache-Control']
    if cc.blank?
      response.headers['Cache-Control'] = 'must-revalidate, max-age=10'
    else
      response.headers['Cache-Control'] << ', must-revalidate, max-age=10' unless cc =~ /must-revalidate/
    end
  end

  def proxy_revalidate
    cc = response.headers['Cache-Control']
    if cc.blank?
      response.headers['Cache-Control'] = 'proxy-revalidate, s-maxage=10'
    else
      response.headers['Cache-Control'] << ', proxy-revalidate, s-maxage=10' unless cc =~ /proxy-revalidate/
    end
  end
end
