class PopulationGroup < ApplicationRecord

  has_many :program_population_groups
  has_many :programs, through: :program_population_groups
end
