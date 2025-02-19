class AssetHost
  def initialize(configuration)
    @host = configuration.domain
    @port = configuration.port
    @protocol = configuration.protocol

    options = { host: @host, scheme: @protocol }
    options[:port] = @port if @port.present?

    @uri = URI::Generic.build(options)
  end

  delegate :to_s, to: :@uri
end
