module BancBoxCrowd
	module Api
		def create_investor options
			object_from_response(BancBoxCrowd::Id, :post, 'createInvestor', options)
		end

		def create_issuer options
			object_from_response(BancBoxCrowd::Id, :post, 'createIssuer', options)
		end

		def create_escrow options
			object_from_response(BancBoxCrowd::Id, :post, 'createEscrowAccount', options)
		end

		def submit_agreement options
			get_response(:post, 'submitAgreement', options)
		end

		def verify_identity options
			data = {
				:generate_questions => boolean_to_yes_no(options.delete(:generate_questions))
			}
			data.merge! options
			get_response(:post, 'verifyIdentity', data)
		end

		def verify_answers options
			get_response(:post, 'verifyAnswers', options)
		end

		def fund_account options
			data = {
				:link_bank_account => boolean_to_y_n(options.delete(:link_bank_account)),
				:submit_timestamp => formatted_time(options.delete(:submit_timestamp)),
			}
			data.merge! options
			get_response(:post, 'fundAccount', data)
		end

		def fund_escrow options
			data = {
				:fund_on_availability => boolean_to_y_n(options.delete(:fund_on_availability))
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

	    def boolean_to_y_n(bool)
	      bool ? 'Y' : 'N'
	    end

	    def boolean_to_yes_no(bool)
	      bool ? 'Yes' : 'No'
	    end

		def get_response(method, endpoint, data)
			ignore_exceptions = data.has_key?[:ignore_exceptions] && data.delete(:ignore_exceptions)	
	      	response = BancBoxCrowd.connection.__send__(method, endpoint, data)
	      	unless ignore_exceptions
		    	if response['error'] != nil
		        	raise BancBoxCrowd::Error.new(response['error'])
		      	end
		  	end
	      	response
    	end

    	def object_from_response(klass, method, endpoint, data)
      		klass.from_response(get_response(method, endpoint, data))
    	end
	end
end