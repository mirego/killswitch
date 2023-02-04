module HtmlHelper
  def logo(options = {})
    render partial: 'shared/logo', locals: { options: }
  end

  def icon(name, label = nil)
    content_tag(:i, '', class: "fa fa-#{name.to_s.tr('_', '-')}") + label.presence.try(:prepend, '  ')
  end

  def nav_active_item?(item)
    ' class="active"'.html_safe if item == content_for(:nav_active_item).try(:to_sym)
  end

  def page_title(base: '')
    parts = []

    parts << content_for(:page_title) if content_for?(:page_title)
    parts << "(#{present(current_organization).name})" if current_organization.present?

    if parts.any?
      "#{parts.join(' ')} — #{base}"
    else
      base
    end
  end

  def bool_icon(value)
    value ? icon(:check) : nil
  end

  def version
    "v#{Killswitch::Application::VERSION}"
  end
end
