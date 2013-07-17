module BancBoxCrowd
  class Error < StandardError

    attr_reader :data

    def initialize(data)
      @data = data
      super(@data.inspect)
    end

    def is_empty?
    	self.message == "nil"
    end
  end
end