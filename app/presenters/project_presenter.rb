class ProjectPresenter < Bourgeois::Presenter
  def to_model
    self
  end

  def curl_example(opts = {})
    url_opts = opts.merge!(key:, version: '_VERSION_')
    api_url = view.api_url(url_opts).gsub('_VERSION_', '$version')

    %(echo -n 'Enter a version number: '; read version; curl -H "Accept-Language: #{I18n.locale}" "#{api_url}")
  end

  def full_name
    "#{view.present(application).name} / #{name}"
  end
end
