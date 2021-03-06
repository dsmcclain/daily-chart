class ChartsController < ApplicationController
  before_action :require_login

  def new
    if current_chart
      flash[:alert] = "You already have a chart"
      redirect_to dashboard_path
    else
      @chart = Chart.new
      @chart.items.build
    end
  end

  def create
    @chart = current_user.build_chart(chart_params)
    if @chart.save
      flash[:notice] = "Created new chart"
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def edit
    @chart = current_chart
  end

  def update
    @chart = current_chart
    @chart.items.clear
    if @chart.update(chart_params)
      flash[:notice] = "Edited chart"
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def chart_params
    params.require(:chart).permit(items_attributes: [:name])
  end
end
