class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  def friendly_created
    created_at.strftime("%B %e, %Y")
  end

  def friendly_updated
    updated_at.strftime("%B %e, %Y")
  end
end
