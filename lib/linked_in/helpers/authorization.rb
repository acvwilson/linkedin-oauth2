module LinkedIn
  module Helpers

    module Authorization

      DEFAULT_OAUTH_OPTIONS = {
        access_token_path:  "/uas/oauth2/accessToken",
        authorize_path:     "/uas/oauth2/authorization",
        api_host:           "https://api.linkedin.com",
        auth_host:          "https://www.linkedin.com"
      }

      def client
        @client ||= ::OAuth2::Client.new(@consumer_token, @consumer_secret, parse_oauth_options)
      end

      def access_token
        @access_token ||= ::OAuth2::AccessToken.new(client, @auth_token, mode: :query, param_name: 'oauth2_access_token')
      end

      def authorize_from_access(atoken)
        @auth_token = atoken
      end

      private

        # since LinkedIn uses api.linkedin.com for request and access token exchanges,
        # but www.linkedin.com for authorize/authenticate, we have to take care
        # of the url creation ourselves.
        def parse_oauth_options
          {
            token_url:      full_oauth_url_for(:access_token,  :api_host),
            authorize_url:  full_oauth_url_for(:authorize,     :auth_host),
            site:           @consumer_options[:site] || @consumer_options[:api_host] || DEFAULT_OAUTH_OPTIONS[:api_host]
          }
        end

        def full_oauth_url_for(url_type, host_type)
          if @consumer_options["#{url_type}_url".to_sym]
            @consumer_options["#{url_type}_url".to_sym]
          else
            host = @consumer_options[:site] || @consumer_options[host_type] || DEFAULT_OAUTH_OPTIONS[host_type]
            path = @consumer_options[:"#{url_type}_path".to_sym] || DEFAULT_OAUTH_OPTIONS["#{url_type}_path".to_sym]
            "#{host}#{path}"
          end
        end

    end

  end
end
