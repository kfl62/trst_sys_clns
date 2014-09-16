# encoding: utf-8
module Clns
  class CacheBook < Trst::CacheBook

    embeds_many :lines,       class_name: 'Clns::CacheBook::Line',      cascade_callbacks: true

  end # CacheBook

  class CacheBook::Line < Trst::CacheBookLine

    embedded_in :cb,          class_name: 'Clns::CacheBook',            inverse_of: :lines

  end # CacheBookIn
end #Clns
