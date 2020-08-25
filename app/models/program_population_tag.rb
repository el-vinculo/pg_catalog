class ProgramPopulationTag < ApplicationRecord

  belongs_to :org
  belongs_to :program
  belongs_to :population_tag
end
