# frozen_string_literal: true

# The client raises ResourceNotFound on 404, and cleanup hooks often delete a
# resource the example itself already deleted.
module Cleanup
  def cleanup
    yield
  rescue ActiveCampaign::ResourceNotFound
    nil
  end
end

RSpec.configure do |config|
  config.include Cleanup
end
