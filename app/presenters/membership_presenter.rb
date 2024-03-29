class MembershipPresenter < Bourgeois::Presenter
  # Structs
  Dropdown = Struct.new(:id, :label)

  def self.membership_types
    @_service_types ||= Camaraderie.membership_types.map do |type|
      Dropdown.new(id: type, label: membership_type_label(type))
    end
  end

  def human_membership_type
    MembershipPresenter.membership_type_label(membership_type)
  end

  def self.membership_type_label(type)
    I18n.t("activerecord.attributes.membership.membership_types.#{type}")
  end
end
