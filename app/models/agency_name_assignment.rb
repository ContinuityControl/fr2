# == Schema Information
#
# Table name: agency_name_assignments
#
#  id              :integer(4)      not null, primary key
#  assignable_id   :integer(4)
#  agency_name_id  :integer(4)
#  position        :integer(4)
#  assignable_type :string(255)
#

class AgencyNameAssignment < ApplicationModel
  validates_presence_of :agency_name

  belongs_to :agency_name
  belongs_to :assignable, :polymorphic => true
  belongs_to :entry, :foreign_key => :assignable_id
  
  has_one :agency_assignment, :foreign_key => :id, :dependent => :destroy
  acts_as_list :scope => 'assignable_id = #{assignable_id} AND assignable_type = \'#{assignable_type}\''
  
  after_create :create_agency_assignments
  after_destroy :destroy_agency_assignments
  private
  def create_agency_assignments
    if agency_name.agency
      assignable.agency_assignments << AgencyAssignment.new(:agency => agency_name.agency, :agency_name_id => agency_name.id)
    end
    true
  end
  
  def destroy_agency_assignments
    if agency_name.agency
      assignable.agencies = assignable.agencies - [agency_name.agency]
    end
    true
  end
end
