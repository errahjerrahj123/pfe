class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Course 
      can :update,   Course 
     can :destroy, Course
     can :edit, Course
  end
end