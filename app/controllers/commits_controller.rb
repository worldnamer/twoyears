class CommitsController < AngularController
  before_filter :authenticate_user!

  def index
  end
end