module BancBoxCrowd
  class Id

    attr_reader :request_id
    attr_reader :id
    attr_reader :error

    # Create a new banc_box id.
    #
    # @param options [Hash] Either a bancbox id or a reference id.
    #   One or the other is required.
    # @option options [Integer] :banc_box_id The bancbox id for the client.
    # @option options [String] :reference_id Your own id for the client.
    # @return [BancBox::Id] The new id.
    def initialize(options={})
      @request_id = options[:request_id]
      @id = options[:id]
      @error = BancBoxCrowd::Error.new(options[:error])
    end

    def self.from_response(response)
      self.new(
        :request_id => response['request_id'],
        :id => response['id'],
        :error => response['error']
      )
    end

    # Convert the id object to a hash appropriate for sending to BancBox
    #
    # @return [Hash] The data hash
    def to_hash
      {
        :request_id => @request_id,
        :id => @id
      }
    end
  end
end