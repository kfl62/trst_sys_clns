# encoding: utf-8
module Clns
  class User < Trst::User

    belongs_to    :unit,   class_name: 'Clns::PartnerFirmUnit',  inverse_of: :users
    has_many      :dlns,   class_name: 'Clns::DeliveryNote',     inverse_of: :signed_by
    has_many      :grns,   class_name: 'Clns::Grn',              inverse_of: :signed_by
    has_many      :csss,   class_name: 'Clns::Cassation',        inverse_of: :signed_by
    has_many      :invs,   class_name: 'Clns::Invoice',          inverse_of: :signed_by
    embeds_many   :logins, class_name: 'Clns::UserLogin'

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    class << self
    end # Class methods

    # @todo
    def login
      logins.find_or_create_by(id_date: Date.today).push(:login,Time.now)
    end
    # @todo
    def logout
      l = logins.find_or_create_by(id_date: Date.today)
      l.push(:logout,Time.now) if l.login.length > l.logout.length
    end
    # @todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
  end # User

  class UserLogin
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::DateHelpers

    field :id_date, type: Date,     default: -> {Date.today}
    field :login,   type: Array,    default: []
    field :logout,  type: Array,    default: []

    embedded_in   :user,  class_name: 'Clns::User'
 end # UserLogin

end # Clns
