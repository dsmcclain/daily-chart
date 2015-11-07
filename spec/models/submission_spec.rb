require "rails_helper"

RSpec.describe Submission do
  describe "data" do
    it "is valid when the data matches the chart's items" do
      chart = Chart.create(items: [Item.new(name: "foo")])
      data = { "foo" => "1" }
      submission = chart.submissions.build(data: data)
      expect(submission).to be_valid
    end

    it "is invalid when the data does not match the chart's items" do
      chart = Chart.create(items: [Item.new(name: "foo")])
      data = { "bar" => "1" }
      submission = chart.submissions.build(data: data)
      expect(submission).to be_invalid
    end
  end
end