module BancBoxCrowd
	module Api
		def create_investor options
			data = {
				:name => options.delete(:name),
				:first_name => options.delete(:first_name),
				:last_name => options.delete(:last_name),
				:email => options.delete(:email),
				:phone => options.delete(:phone),
				:address_1 => options.delete(:address_1),
				:city => options.delete(:city),
				:state => options.delete(:state),
				:zip => options.delete(:zip),
				:ssn => options.delete(:ssn),
				:dob => options.delete(:dob),
				:bank_name => options.delete(:bank_name),
				:account_number => options.delete(:account_number),
				:account_type => options.delete(:account_type),
				:routing_number => options.delete(:routing_number),
				:created_by => options.delete(:created_by)
			}
			data.merge! options

			object_from_response(BancBoxCrowd::Id, :post, 'createInvestor',data)
		end

		def submit_agreement options
			get_response(:post, 'submitAgreement', options)
		end

		def fund_account options
			data = {
				:link_bank_account => boolean_to_yes_no(options.delete(:link_bank_account)),
				:submit_timestamp => formatted_time(options.delete(:submit_timestamp)),
			}
			data.merge! options
			get_response(:post, 'fundAccount', data)
		end

		def fund_escrow options
			data = {
				:fund_on_availability => boolean_to_yes_no(options.delete(:fund_on_availability))
			}
			data.merge! options
			get_response(:post, 'fundEscrow', data)
		end

		private

		def formatted_time(time)
	      time && time.strftime('%Y-%m-%d %H:%M:%S')
	    end

	    def formatted_date(date)
	      date && date.strftime('%Y-%m-%d')
	    end

	    def boolean_to_yes_no(bool)
	      bool ? 'Y' : 'N'
	    end

		def get_response(method, endpoint, data)
	      response = BancBoxCrowd.connection.__send__(method, endpoint, data)
	      if response['error'] != nil
	        raise BancBoxCrowd::Error.new(response['error'])
	      end
	      response
    	end

    	def object_from_response(klass, method, endpoint, data)
      		klass.from_response(get_response(method, endpoint, data))
    	end
	end
end