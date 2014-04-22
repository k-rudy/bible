require 'spec_helper'

describe Bible::Book do
  it { should have_many :verses }

  it { should have_fields(:name, :title, :title_full) }
  it { should have_field(:chapters_count).of_type(Integer) }

  describe '#latest_verse_order' do
    
    context 'when there are verses' do
      
      let(:first_verse) { double('first_verse', order: 1) }
      let(:last_verse) { double('last_verse', order: 2) }
      let(:verses) { double('verses', of_chapter: [ first_verse, last_verse ]) }
      before { subject.stub(verses: verses) } 
      
      it 'returns latest verse order' do
        expect(subject.latest_verse_order(1)).to eq(2)
      end
    end
    
    context 'when there are no verses' do
      
      let(:verses) { double('verses', of_chapter: [ ]) }
      before { subject.stub(verses: verses) } 
      
      it 'returns 0' do
        expect(subject.latest_verse_order(1)).to eq(0)
      end
    end
  end
end
