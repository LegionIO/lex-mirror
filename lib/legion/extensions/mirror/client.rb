# frozen_string_literal: true

require 'legion/extensions/mirror/helpers/constants'
require 'legion/extensions/mirror/helpers/observed_behavior'
require 'legion/extensions/mirror/helpers/mirror_system'
require 'legion/extensions/mirror/runners/mirror'

module Legion
  module Extensions
    module Mirror
      class Client
        include Runners::Mirror

        def initialize(mirror_system: nil, **)
          @mirror_system = mirror_system || Helpers::MirrorSystem.new
        end

        private

        attr_reader :mirror_system
      end
    end
  end
end
