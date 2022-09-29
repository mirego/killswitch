module ErrorHelper
  def render_error_messages(record)
    return unless record.errors.any?

    render partial: 'shared/error_messages', locals: { record: record }
  end

  # Return an exception's bracktrace formatted into a nice
  # plain list. It also wraps lines from the application
  # directory in <span> elements.
  def pretty_backtrace(exception)
    exception.backtrace.map do |line|
      if line =~ %r{#{Rails.root}}
        content_tag(:span, line, class: 'app-line')
      else
        line
      end
    end.join("\n")
  end
end
