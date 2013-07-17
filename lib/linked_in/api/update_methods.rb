module LinkedIn
  module Api

    module UpdateMethods

      def add_share(share)
        path = "/people/~/shares"
        defaults = {share: {visibility: {code: "anyone"}}}
        post(path, body: hash_to_xml(defaults[:share].merge(share)), "Content-Type" => "application/xml")
      end

      def join_group(group_id)
        path = "/people/~/group-memberships/#{group_id}"
        body = {'membership-state' => {code: 'member' }}
        put(path, body: hash_to_xml(body), "Content-Type" => "application/xml")
      end

      def add_job_bookmark(bookmark)
        path = "/people/~/job-bookmarks"
        body = {job: {id: bookmark}}
        post(path, body: hash_to_xml(body), "Content-Type" => "application/xml")
      end

      # def share(options={})
      #   path = "/people/~/shares"
      #   defaults = { visability: 'anyone' }
      #   post(path, share_to_xml(defaults.merge(options)))
      # end
      #
      def update_comment(network_key, comment)
        path = "/people/~/network/updates/key=#{network_key}/update-comments"
        body = {comment: comment}
        post(path, body: hash_to_xml(body), "Content-Type" => "application/xml")
      end
      #
      # def update_network(message)
      #   path = "/people/~/person-activities"
      #   post(path, network_update_to_xml(message))
      # end
      #

      def like_share(network_key)
        path = "/people/~/network/updates/key=#{network_key}/is-liked"
        body = {'is-liked' => true}
        put(path, body: hash_to_xml(body), "Content-Type" => "application/xml")
      end

      def unlike_share(network_key)
        path = "/people/~/network/updates/key=#{network_key}/is-liked"
        body = {'is-liked' => false}
        put(path, body: hash_to_xml(body), "Content-Type" => "application/xml")
      end

      def send_message(subject, body, recipient_paths)
        path = "/people/~/mailbox"
      
        message = {
            'subject' => subject, 
            'body' => body,
            'recipients' => {
                'values' => recipient_paths.map do |profile_path| 
                  { 'person' => { '_path' => "/people/#{profile_path}" } } 
                end
            }
        }
        post(path, body: hash_to_xml(message), "Content-Type" => "application/xml")
      end

      private

        def hash_to_xml(hash)
          ::XmlSimple.xml_out(hash, keeproot: true, noindent: true)
        end

    end

  end
end
