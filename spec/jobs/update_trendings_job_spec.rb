require 'rails_helper'

RSpec.describe UpdateTrendingsJob, type: :job do
  describe "#perform_later" do
    it "check if job was enqueued" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        UpdateTrendingsJob.perform_later
      }.to have_enqueued_job
    end

    it 'is in trendings queue' do
      expect(UpdateTrendingsJob.new.queue_name).to eq('trendings')
    end  
  end
end