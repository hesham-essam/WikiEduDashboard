# frozen_string_literal: true

#= Controller for campaign/course functionality
class ExploreController < ApplicationController
  respond_to :html

  def index
    # 'cohort' is the old name for campaign. We accept 'cohort' as an alternative
    # Redirect to new campaign overview page if a parameter is given, for backwards compatibility
    campaign_param = params[:campaign] || params[:cohort]
    redirect_to campaign_path(campaign_param) if campaign_param
    @presenter = CoursesPresenter.new(current_user: current_user,
                                      campaign_param: CampaignsPresenter.default_campaign_slug)
    @campaign = @presenter.campaign
    redirect_to '/' unless @campaign
    set_search if params[:search].present?
  end

  def set_search
    search_presenter = CoursesPresenter.new(
      current_user: current_user,
      courses_list: Course.where(private: false)
    )
    @query = params[:search]
    @results = search_presenter.search_courses(@query)
  end
end
