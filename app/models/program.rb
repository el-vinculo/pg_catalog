class Program < ApplicationRecord
  belongs_to :org
  has_many :program_sites
  has_many :sites, through: :program_sites

  has_many :program_pocs
  has_many :pocs, through: :program_pocs

  has_many :program_service_groups
  has_many :service_groups, through: :program_service_groups

  has_many :program_service_tags
  has_many :program_population_groups
  has_many :program_population_tags

end
