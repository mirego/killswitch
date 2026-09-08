require 'spec_helper'

describe API::BehaviorsController, type: :request do
  describe 'GET /killswitch' do
    subject { response }
    before do
      allow(Analytics::ProjectActivityTracker).to receive(:track)
      get '/killswitch', params:
    end

    context 'with missing “version” parameter' do
      let(:params) { {} }
      it { expect(response.status).to eq 400 }
    end

    context 'with invalid “version” parameter' do
      let(:params) { { version: '🐸' } }
      it { expect(response.status).to eq 400 }
    end

    context 'with missing “key” parameter' do
      let(:params) { { version: '1.0' } }
      it { expect(response.status).to eq 400 }
    end

    context 'with unknown “key” parameter' do
      let(:params) { { version: '1.0', key: 'foo' } }
      it { expect(response.status).to eq 404 }

      it 'does not track activity' do
        expect(Analytics::ProjectActivityTracker).not_to have_received(:track)
      end
    end

    context 'with valid parameters' do
      let(:project) { create(:project) }
      let(:params) { { version: '1.0', key: project.key } }

      it { expect(response.headers['Vary']).to eq 'Accept-Language, Origin' }
      it { expect(response.status).to eq 200 }

      it 'tracks the project activity' do
        expect(Analytics::ProjectActivityTracker).to have_received(:track).with(project.id)
      end
    end

    context 'with missing “key” parameter (tracking)' do
      let(:params) { { version: '1.0' } }

      it 'does not track activity' do
        expect(Analytics::ProjectActivityTracker).not_to have_received(:track)
      end
    end
  end
end
