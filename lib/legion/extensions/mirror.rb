# frozen_string_literal: true

require 'securerandom'
require 'legion/extensions/mirror/version'
require 'legion/extensions/mirror/helpers/constants'
require 'legion/extensions/mirror/helpers/observed_behavior'
require 'legion/extensions/mirror/helpers/mirror_system'
require 'legion/extensions/mirror/runners/mirror'
require 'legion/extensions/mirror/client'

module Legion
  module Extensions
    module Mirror
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
