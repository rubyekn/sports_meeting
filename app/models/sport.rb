class Sport < ApplicationRecord
  validates :teamone,:status,:title,presence: true
  #validates :teamone,numericality: { only_integer: true }
  #validates :teamone,:teamtwo, length:{maximum:2}
  validates :wp,:lp, length:{maximum:30}
end
