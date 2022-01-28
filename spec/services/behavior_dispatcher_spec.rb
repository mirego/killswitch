require 'spec_helper'

describe BehaviorDispatcher do
  describe :InstanceMethods do
    describe :dispatch! do
      let(:request) { ActionDispatch::TestRequest.new('action_dispatch.request.parameters' => params) }
      let(:dispatcher) { BehaviorDispatcher.new }

      context 'with all required and valid parameters' do
        let(:project) { create(:project) }
        let(:params) { { key: project.key, version: '5.0.0' } }

        it { expect { dispatcher.dispatch!(request) }.to_not raise_error }
      end

      context 'with invalid parameters' do
        context 'with missing key' do
          let(:params) { { version: '5.0.0' } }
          it { expect { dispatcher.dispatch!(request) }.to raise_error(BehaviorDispatcher::MissingParameter, 'Missing or invalid “key” parameter') }
        end

        context 'with unknown project key' do
          let(:params) { { key: 'FOO', version: '5.0.0' } }
          it { expect { dispatcher.dispatch!(request) }.to raise_error(ActiveRecord::RecordNotFound) }
        end

        context 'with missing version key' do
          let(:params) { { key: 'FOO' } }
          it { expect { dispatcher.dispatch!(request) }.to raise_error(BehaviorDispatcher::MissingParameter, 'Missing or invalid “version” parameter') }
        end

        context 'with invalid version key' do
          let(:params) { { kee: 'FOO', version: '😈' } }
          it { expect { dispatcher.dispatch!(request) }.to raise_error(BehaviorDispatcher::MissingParameter, 'Missing or invalid “version” parameter') }
        end
      end
    end

    describe :matching_behavior do
      let(:request) { ActionDispatch::TestRequest.new(env) }
      let(:env) do
        env = ActionDispatch::TestRequest::DEFAULT_ENV
        env['HTTP_ACCEPT_LANGUAGE'] = language
        env['action_dispatch.request.parameters'] = params
        env['rack-accept.request'] = Rack::Accept::Request.new(env)
      end

      let(:params) { { key: project.key, version: '5.0.0' } }
      let(:dispatcher) { BehaviorDispatcher.new }
      let(:project) { create(:project) }
      let(:language) { nil }
      let(:time_now) { Time.zone.parse('2018-04-24 09:00:00 UTC') }

      before do
        allow(Time).to receive(:now).and_return(time_now)
        behavior1
        behavior2
        dispatcher.dispatch!(request)
      end

      context 'with language' do
        context 'defined by HTTP header' do
          context 'with a behavior matching language and version' do
            let(:language) { 'fr' }
            let(:behavior1) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'eq', language: 'en') }
            let(:behavior2) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'eq', language: 'fr') }

            it { expect(dispatcher.matching_behavior).to eq behavior2 }
          end

          context 'with a behavior matching language but not version' do
            let(:language) { 'fr' }
            let(:behavior1) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'eq', language: 'en') }
            let(:behavior2) { create(:behavior, project: project, version_number: '6.0.0', version_operator: 'eq', language: 'fr') }

            it { expect(dispatcher.matching_behavior).to eq Behavior::DefaultBehavior }
          end
        end

        context 'defined by query string parameter' do
          let(:language) { nil }
          let(:params) { { key: project.key, version: '5.0.0', http_accept_language: language } }

          context 'with a behavior matching language and version' do
            let(:language) { 'fr' }
            let(:behavior1) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'eq', language: 'en') }
            let(:behavior2) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'eq', language: 'fr') }

            it { expect(dispatcher.matching_behavior).to eq behavior2 }
          end

          context 'with a behavior matching language but not version' do
            let(:language) { 'fr' }
            let(:behavior1) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'eq', language: 'en') }
            let(:behavior2) { create(:behavior, project: project, version_number: '6.0.0', version_operator: 'eq', language: 'fr') }

            it { expect(dispatcher.matching_behavior).to eq Behavior::DefaultBehavior }
          end
        end
      end

      context 'with versions' do
        context 'with a behavior matching a < operator' do
          let(:behavior1) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'lt') }
          let(:behavior2) { create(:behavior, project: project, version_number: '6.0.0', version_operator: 'lt') }

          it { expect(dispatcher.matching_behavior).to eq behavior2 }
        end

        context 'with a behavior matching a <= operator' do
          let(:behavior1) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'lte') }
          let(:behavior2) { create(:behavior, project: project, version_number: '6.0.0', version_operator: 'lte') }

          it { expect(dispatcher.matching_behavior).to eq behavior1 }
        end

        context 'with a behavior matching a == operator' do
          let(:behavior1) { create(:behavior, project: project, version_number: '4.0.0', version_operator: 'eq') }
          let(:behavior2) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'eq') }

          it { expect(dispatcher.matching_behavior).to eq behavior2 }
        end

        context 'with a behavior matching a >= operator' do
          let(:behavior1) { create(:behavior, project: project, version_number: '6.0.0', version_operator: 'gte') }
          let(:behavior2) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'gte') }

          it { expect(dispatcher.matching_behavior).to eq behavior2 }
        end

        context 'with a behavior matching a > operator' do
          let(:behavior1) { create(:behavior, project: project, version_number: '4.5.0', version_operator: 'gt') }
          let(:behavior2) { create(:behavior, project: project, version_number: '5.0.0', version_operator: 'gt') }

          it { expect(dispatcher.matching_behavior).to eq behavior1 }
        end

        context 'with no behavior matching' do
          let(:behavior1) { create(:behavior, project: project, version_number: '1.0.0', version_operator: 'eq') }
          let(:behavior2) { create(:behavior, project: project, version_number: '2.0.0', version_operator: 'eq') }

          it { expect(dispatcher.matching_behavior).to eq Behavior::DefaultBehavior }
        end
      end

      context 'with times' do
        context 'with a behavior matching a < operator' do
          let(:behavior1) { create(:behavior, project: project, version_number: '6.0.0', version_operator: 'lt', time: '2018-04-24 08:00:00', time_operator: 'lt') }
          let(:behavior2) { create(:behavior, project: project, version_number: '6.0.0', version_operator: 'lt', time: '2018-04-24 10:00:00', time_operator: 'lt') }

          it { expect(dispatcher.matching_behavior).to eq behavior2 }
        end

        context 'with a behavior matching a > operator' do
          let(:behavior1) { create(:behavior, project: project, version_number: '6.0.0', version_operator: 'lt', time: '2018-04-24 08:00:00', time_operator: 'gt') }
          let(:behavior2) { create(:behavior, project: project, version_number: '6.0.0', version_operator: 'lt', time: '2018-04-24 10:00:00', time_operator: 'gt') }

          it { expect(dispatcher.matching_behavior).to eq behavior1 }
        end
      end
    end
  end
end
