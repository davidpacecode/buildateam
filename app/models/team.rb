class Team < ApplicationRecord

  belongs_to :pg, class_name: "Player", foreign_key: :pg_id, optional: true
  belongs_to :sg, class_name: "Player", foreign_key: :sg_id, optional: true
  belongs_to :sf, class_name: "Player", foreign_key: :sf_id, optional: true
  belongs_to :pf, class_name: "Player", foreign_key: :pf_id, optional: true
  belongs_to :c,  class_name: "Player", foreign_key: :c_id,  optional: true

  # after_initialize :set_defaults

  # def set_defaults
  #   unique_random_numbers = (1..100).to_a.sample(5)
  #   self.pg_id ||= unique_random_numbers[0]
  #   self.sg_id ||= unique_random_numbers[1]
  #   self.sf_id ||= unique_random_numbers[2]
  #   self.pf_id ||= unique_random_numbers[3]
  #   self.c_id  ||= unique_random_numbers[4]
  # end
end
