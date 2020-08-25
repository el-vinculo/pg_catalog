class ServiceGroup < ApplicationRecord

  has_many :program_service_groups
  has_many :programs, through: :program_service_groups

end
