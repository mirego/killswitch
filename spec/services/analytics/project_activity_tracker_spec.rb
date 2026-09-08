require 'spec_helper'

describe Analytics::ProjectActivityTracker do
  describe '.track' do
    let(:project) { create(:project) }
    let(:date) { Date.current.to_s }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('ANALYTICS_ENABLED').and_return('true')
    end

    it 'increments the daily counter' do
      described_class.track(project.id)
      described_class.track(project.id)

      expect(KILLSWITCH_REDIS.get("analytics:requests:#{project.id}:#{date}")).to eq '2'
    end

    it 'registers the project as active for the day' do
      described_class.track(project.id)

      expect(KILLSWITCH_REDIS.smembers("analytics:active_projects:#{date}")).to include(project.id.to_s)
    end

    it 'registers the date as active' do
      described_class.track(project.id)

      expect(KILLSWITCH_REDIS.smembers('analytics:active_dates')).to include(date)
    end

    it 'stores the last seen timestamp' do
      at = Time.zone.now

      described_class.track(project.id, at:)

      expect(KILLSWITCH_REDIS.get("analytics:last_seen:#{project.id}")).to eq at.utc.iso8601
    end

    it 'sets a TTL on the daily counter' do
      described_class.track(project.id)

      ttl = KILLSWITCH_REDIS.ttl("analytics:requests:#{project.id}:#{date}")
      expect(ttl).to be_within(60).of(48.hours.to_i)
    end

    context 'when analytics is disabled' do
      before do
        allow(ENV).to receive(:[]).with('ANALYTICS_ENABLED').and_return(nil)
      end

      it 'does not write anything to Redis' do
        described_class.track(project.id)

        expect(KILLSWITCH_REDIS.keys('analytics:*')).to be_empty
      end
    end

    context 'when Redis is down' do
      before do
        allow(KILLSWITCH_REDIS).to receive(:pipelined).and_raise(Redis::BaseConnectionError)
        allow(Rails.logger).to receive(:warn)
      end

      it 'does not raise' do
        expect { described_class.track(project.id) }.not_to raise_error
      end

      it 'logs a warning' do
        described_class.track(project.id)

        expect(Rails.logger).to have_received(:warn).with(/Analytics tracking failed/)
      end
    end
  end
end
