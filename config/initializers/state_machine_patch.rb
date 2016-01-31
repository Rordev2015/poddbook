require 'state_machine/version'

unless StateMachine::VERSION == '1.2.0'
  # If you see this message, please test removing this file
  # If it's still required, please bump up the version above
  Rails.logger.warn "Please remove me, StateMachine version has changed"
end

module StateMachine
  module Integrations
     module ActiveModel
        public :around_validation
     end

     module ActiveRecord
        public :around_save
     end
  end
end