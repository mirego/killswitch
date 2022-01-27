module Sprockets
  class ES6
    DEFAULT_OPTIONS = {
      'moduleIds' => true,
      'modules' => 'amd',
      'keepModuleIdExtensions' => false,
      'loose' => %w(es6.classes)
    }

    def self.instance
      @instance ||= new(DEFAULT_OPTIONS)
    end
  end
end

# NOTE: We shouldn’t have to override `Sprockets::ES6.instance` to pass
#       custom options to the processor. We should simply be able to do this:
#
#       Sprockets.register_transformer 'text/ecmascript-6', 'application/javascript', Sprockets::ES6.new(options)
