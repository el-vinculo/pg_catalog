class Poc < ApplicationRecord
  belongs_to :org

  has_many :program_pocs
  has_many :programs, through: :program_pocs

  has_many :site_pocs
  has_many :sites, through: :site_pocs

end
