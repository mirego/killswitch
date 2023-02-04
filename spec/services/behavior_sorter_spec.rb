require 'spec_helper'

describe BehaviorSorter do
  describe :reorder! do
    let(:project) { create(:project) }
    let(:behaviors) { create_list(:behavior, 10, project:) }

    let(:sorter) { BehaviorSorter.new(project) }
    before { sorter.reorder! order.map(&:to_s) }

    context 'with reverse order' do
      let(:order) { behaviors.map(&:id).reverse }
      it { expect(project.behaviors.map(&:id)).to eq order }
    end

    context 'with random order' do
      let(:order) { behaviors.map(&:id).shuffle }
      it { expect(project.behaviors.map(&:id)).to eq order }
    end
  end
end
