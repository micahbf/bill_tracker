class StaticPagesController < ApplicationController
  def root
    if current_user
      @current_user_id = current_user.id
      @users = User.all
      @users_with_balances = current_user.user_ids_with_outstanding_balance
      @groups = current_user.groups.includes(:user_group_memberships)
      @currencies = Currency.all
      render :root
    else
      render :landing
    end
  end
end
