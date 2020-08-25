class Site < ApplicationRecord
  belongs_to :org

  has_many :program_sites
  has_many :programs, through: :program_sites

  has_many :site_pocs
  has_many :pocs, through: :site_pocs

  has_one :location
end
