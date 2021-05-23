class Site < ApplicationRecord
  belongs_to :org

  has_many :program_sites, dependent: :destroy
  has_many :programs, through: :program_sites

  has_many :site_pocs, dependent: :destroy
  has_many :pocs, through: :site_pocs

  # has_one :location
end
