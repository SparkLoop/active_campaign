# frozen_string_literal: true

module ActiveCampaign
  module API
    #
    # Interface for campaigns API
    #
    # @author Petar Risteski <risteskipetar3@gmail.com>
    #
    module Campaigns
      #
      # Retrieve a list of campaigns
      #
      # @return [Hash] a hash with a list of campaigns
      #
      def campaigns(params = {})
        get("campaigns", **params)
      end

      #
      # Get a single campaign
      #
      # @param [Integer] id the id of a campaign to show
      #
      # @return [Hash]
      #
      def show_campaign(campaign_id)
        get("campaigns", id: campaign_id)
      end

    end
  end
end
