module Base
 extend ActiveSupport::Concern
 included do
    include Mongoid::Document
    include Mongoid::Timestamps
    # include Mongoid::Paranoia # Without real Deletions, only set deleted_at
  end
end
