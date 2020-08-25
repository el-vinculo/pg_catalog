class Org < ApplicationRecord
  has_many :programs, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :pocs
  has_many :program_service_groups
  has_many :program_service_tags
  has_many :program_population_groups
  has_many :program_population_tags
  has_many :grab_lists
  has_many :scopes

end
