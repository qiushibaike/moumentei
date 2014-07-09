class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  # Uncomment this responder if you want your resources to redirect to the collection
  # path (index action) instead of the resource path for POST/PUT/DELETE requests.
  # include Responders::CollectionResponder
  # def to_json
    # @format = :json
    # api_behavior
    # defined?(super) ? super : to_format
    # render json: @resource
  # end
end
