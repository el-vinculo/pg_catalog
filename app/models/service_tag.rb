class ServiceTag < ApplicationRecord

  has_many :program_service_tags
  has_many :programs, through: :program_service_tags
end
