module HtmlHelper
  def logo(options = {})
    %Q{
      <svg class="#{options[:class]}" viewBox="0 0 836 836" xmlns="http://www.w3.org/2000/svg"><g fill="#fff" fill-rule="evenodd"><circle fill-opacity=".126" cx="418" cy="418" r="418"/><path d="m410.419 162.065-196 106.4c-5.301 2.894-8.797 8.832-8.75 14.875 0 127.53 26.562 210.34 66.148 268.62 39.59 58.281 91.246 90.93 137.55 120.57 5.39 3.473 12.812 3.473 18.199 0 46.305-29.645 97.957-62.293 137.55-120.57 39.593-58.277 66.148-141.09 66.148-268.62.043-6.043-3.45-11.98-8.75-14.875l-196-106.4c-6.106-2.941-10.758-2.559-16.102 0h.007Zm8.05 33.949v442.4c-43.258-27.812-85.898-56.879-118.82-105.35-34.223-50.383-58.457-123.39-59.852-240.1l178.672-96.95Z" fill-rule="nonzero"/></g></svg>
    }.html_safe
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
