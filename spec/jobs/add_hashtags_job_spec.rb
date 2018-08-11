require 'rails_helper'

RSpec.describe AddHashtagsJob, type: :job do
  describe "#perform_later" do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet, user: user) }

    before { ActiveJob::Base.queue_adapter = :test }

    it "have enqueued" do
      expect {
        AddHashtagsJob.perform_later(tweet.body)
      }.to have_enqueued_job
    end

    it 'is in trendings queue' do
      expect(AddHashtagsJob.new.queue_name).to eq('trendings')
    end
  end
end
