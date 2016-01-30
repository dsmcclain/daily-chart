# == Schema Information
#
# Table name: charts
#
#  id      :integer          not null, primary key
#  user_id :integer
#

class Chart < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_many :submissions, -> { order(:date) }

  accepts_nested_attributes_for :items

  def item_names
    items.map(&:name)
  end

  def submission_pending?
    submissions.pending?
  end

  def scorables
    Scorables.for(ScorableDays.for(self), submissions.to_a)
  end

  def scores
    scorables.map(&:score)
  end

  def percentages
    scorables.map(&:percent)
  end

  def last_seven_days
    last(7).map(&:weekday)
  end

  def daily_percentages
    last(7).map(&:percent)
  end

  def weekly_averages
    scorables.each_slice(7).map do |week|
      week.map(&:percent).inject(:+) / week.size
    end
  end

  def weeks_all_time
    1.upto((scorables.size / 7) + 1).to_a
  end

  def best_this_week
    items.max_by { |item| weekly_score_for(item) }.name
  end

  def worst_this_week
    items.min_by { |item| weekly_score_for(item) }.name
  end

  private

  def last(x_days)
    scorables.last(x_days)
  end

  def weekly_score_for(item)
    last(7).map { |scorable| scorable.score_for(item.name) }.reduce(:+)
  end
end
