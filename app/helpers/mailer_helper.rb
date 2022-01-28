module MailerHelper
  # Return the value of the `style` attribute for an element,
  # based on default styles.
  def inline_styles(to_merge = {})
    defaults = {
      :'font-family' => 'Helvetica, Arial, sans-serif',
      :'font-weight' => 300,
      :'font-size' => '14px',
      :'line-height' => '1.5',
      :color => '#5c5c5c'
    }

    defaults.merge(to_merge).reduce('') do |memo, (property, value)|
      memo << "#{property}: #{value}; "
    end
  end
end
