class Team < ApplicationRecord

  belongs_to :pg, class_name: "Player", foreign_key: :pg_id, optional: true
  belongs_to :sg, class_name: "Player", foreign_key: :sg_id, optional: true
  belongs_to :sf, class_name: "Player", foreign_key: :sf_id, optional: true
  belongs_to :pf, class_name: "Player", foreign_key: :pf_id, optional: true
  belongs_to :c,  class_name: "Player", foreign_key: :c_id,  optional: true

end
