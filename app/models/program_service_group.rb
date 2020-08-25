class ProgramServiceGroup < ApplicationRecord
  belongs_to :org
  belongs_to :program

  belongs_to :service_group
end
