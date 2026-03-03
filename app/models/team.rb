class Team < ApplicationRecord

  belongs_to :pg, class_name: "Player", foreign_key: :pg_id, optional: true
  belongs_to :sg, class_name: "Player", foreign_key: :sg_id, optional: true
  belongs_to :sf, class_name: "Player", foreign_key: :sf_id, optional: true
  belongs_to :pf, class_name: "Player", foreign_key: :pf_id, optional: true
  belongs_to :c,  class_name: "Player", foreign_key: :c_id,  optional: true

  after_initialize :set_defaults

  def set_defaults
    self.pg_id ||= 1
    self.sg_id ||= 2
    self.sf_id ||= 3
    self.pf_id ||= 4
    self.c_id  ||= 5
  end
end
