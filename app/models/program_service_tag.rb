class ProgramServiceTag < ApplicationRecord

  belongs_to :org
  belongs_to :program
  belongs_to :service_tag

end
