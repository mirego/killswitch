class AssetHost
  def initialize(configuration)
    @host = configuration.domain
    @port = configuration.port
    @protocol = configuration.protocol

    options = { host: @host, scheme: @protocol }
    options.merge! port: @port if @port.present?

    @uri = URI::Generic.build(options)
  end

  def to_s
    @uri.to_s
  end
end
