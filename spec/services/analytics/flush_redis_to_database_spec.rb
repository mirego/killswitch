require 'spec_helper'

describe Analytics::FlushRedisToDatabase do
  let(:tracker) { Analytics::ProjectActivityTracker }
  let(:project) { create(:project) }
  let(:yesterday) { Date.yesterday.to_s }
  let(:today) { Date.current.to_s }

  def seed_redis(project_id, date, count, last_seen: Time.zone.now)
    KILLSWITCH_REDIS.set(tracker.counter_key(project_id, date), count)
    KILLSWITCH_REDIS.sadd(tracker.active_projects_key(date), project_id)
    KILLSWITCH_REDIS.sadd(tracker.active_dates_key, date)
    KILLSWITCH_REDIS.set(tracker.last_seen_key(project_id), last_seen.utc.iso8601)
  end

  describe 'daily counters' do
    it 'upserts past date counters into project_activity_dailies' do
      seed_redis(project.id, yesterday, 42)

      described_class.call

      daily = ProjectActivityDaily.find_by(project:, date: yesterday)
      expect(daily.request_count).to eq 42
    end

    it 'cleans up Redis keys for flushed dates' do
      seed_redis(project.id, yesterday, 42)

      described_class.call

      expect(KILLSWITCH_REDIS.exists?(tracker.counter_key(project.id, yesterday))).to be false
      expect(KILLSWITCH_REDIS.exists?(tracker.active_projects_key(yesterday))).to be false
      expect(KILLSWITCH_REDIS.smembers(tracker.active_dates_key)).not_to include(yesterday)
    end

    it 'does not flush the current day counters' do
      seed_redis(project.id, today, 42)

      described_class.call

      expect(ProjectActivityDaily.find_by(project:, date: today)).to be_nil
      expect(KILLSWITCH_REDIS.get(tracker.counter_key(project.id, today))).to eq '42'
    end

    it 'adds up counts when a row already exists' do
      create(:project_activity_daily, project:, date: yesterday, request_count: 10)
      seed_redis(project.id, yesterday, 42)

      described_class.call

      expect(ProjectActivityDaily.find_by(project:, date: yesterday).request_count).to eq 52
    end

    it 'is idempotent across multiple flushes with no new traffic' do
      seed_redis(project.id, yesterday, 42)

      described_class.call
      described_class.call

      expect(ProjectActivityDaily.find_by(project:, date: yesterday).request_count).to eq 42
    end

    it 'handles multiple projects and dates' do
      other_project = create(:project)
      seed_redis(project.id, yesterday, 10)
      seed_redis(other_project.id, yesterday, 20)

      described_class.call

      expect(ProjectActivityDaily.find_by(project:, date: yesterday).request_count).to eq 10
      expect(ProjectActivityDaily.find_by(project: other_project, date: yesterday).request_count).to eq 20
    end
  end

  describe 'last_seen_at' do
    it 'persists last_seen_at on the project for current day activity' do
      at = Time.zone.now
      seed_redis(project.id, today, 1, last_seen: at)

      described_class.call

      expect(project.reload.last_seen_at.change(usec: 0)).to eq at.utc.change(usec: 0)
    end

    it 'does not update the database again when last_seen has not changed' do
      at = Time.zone.now
      seed_redis(project.id, today, 1, last_seen: at)

      described_class.call

      expect do
        described_class.call
      end.not_to(change { project.reload.last_seen_at })
    end

    it 'updates the database when last_seen has changed' do
      seed_redis(project.id, today, 1, last_seen: 1.hour.ago)

      described_class.call

      at = Time.zone.now
      KILLSWITCH_REDIS.set(tracker.last_seen_key(project.id), at.utc.iso8601)

      described_class.call

      expect(project.reload.last_seen_at.change(usec: 0)).to eq at.utc.change(usec: 0)
    end
  end

  describe 'lock' do
    it 'does nothing when another flush holds the lock' do
      KILLSWITCH_REDIS.set(described_class::LOCK_KEY, 1)
      seed_redis(project.id, yesterday, 42)

      described_class.call

      expect(ProjectActivityDaily.find_by(project:, date: yesterday)).to be_nil
    end

    it 'releases the lock after a successful flush' do
      described_class.call

      expect(KILLSWITCH_REDIS.exists?(described_class::LOCK_KEY)).to be false
    end
  end
end
