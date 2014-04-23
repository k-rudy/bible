require 'spec_helper'

describe Bible::Scrapers::Ru do
  
  subject { Bible::Scrapers::Ru }
  
  describe '#book_mapping' do
    
    let(:book) { double('book', chapters_count: 1) }
    
    context 'when there is a mapping for the book' do
      
      before { book.stub(title: 'Gn') }
      
      it 'returns mapping value' do
        expect(subject.send(:book_mapping, book)).to eq('ge')
      end
    end
  end
  
  describe '#scrape_verse' do
    
    context 'Offline test' do
      
      before { subject.stub(open: File.open(File.expand_path("../../../../support/fixtures/translations/ru.html", __FILE__))) }
      
      it 'returns verse text' do
        expect(subject.send(:scrape_verse, 'ge', 1, 1)).to eq("В начале сотворил Бог небо и землю.")
      end
    end
    
    context 'API test' do
    
      context 'when the verse number exists' do
      
        it 'returns verse text' do
          pending 'integrated API checks are suspended due to performance reasons'
          expect(subject.send(:scrape_verse, 'ge', 1, 1)).to eq("В начале сотворил Бог небо и землю.")
        end
      end
    
      context 'when the verse number doesnt exist' do
      
        it 'returns nil' do
          pending 'integrated API checks are suspended due to performance reasons'
          expect(subject.send(:scrape_verse, 'ge', 1, 100)).to be_nil
        end
      end
    end
  end
end
