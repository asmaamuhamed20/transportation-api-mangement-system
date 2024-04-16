# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user (not logged in)

    case user.role.to_sym
    when :admin
      can :manage, :all
    when :user
      can :read, :update, Ride
      # Add other permissions for regular users as needed
    else
      # Guest user or unexpected role, no special permissions
    end
  end
end
