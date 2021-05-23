class Program < ApplicationRecord
  belongs_to :org
  has_many :program_sites, dependent: :destroy
  has_many :sites, through: :program_sites

  has_many :program_pocs, dependent: :destroy
  has_many :pocs, through: :program_pocs

  has_many :program_service_groups, dependent: :destroy
  has_many :service_groups, through: :program_service_groups

  has_many :program_service_tags, dependent: :destroy
  has_many :service_tags, through: :program_service_tags


  has_many :program_population_groups, dependent: :destroy
  has_many :population_groups, through: :program_population_groups


  has_many :program_population_tags


end
