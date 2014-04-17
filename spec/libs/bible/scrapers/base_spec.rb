require 'spec_helper'

describe Bible::Scrapers::Base do
  
  subject { Bible::Scrapers::Base }
  let(:book) { double('book', chapters_count: 1) }
  
  describe '#url' do
    
    before { subject.stub(translation: 'ru') }
    
    it 'returns translation url from config' do
      expect(subject.send :url).to be_present
    end
  end
  
  describe '#translation' do
    
    it 'is evaluated from the class name' do
      expect(subject.send :translation).to eq('base')
    end
  end
  
  describe '#scrape' do
    
    before { Bible::Book.stub(all: [ book ]) }
    
    it 'runs #scrape_book for each Bible::Book entry' do
      expect(subject).to receive(:scrape_book).with(book)
      subject.scrape
    end
  end
  
  describe '#scrape_book' do
    
    it 'scrapes each chapter' do
      expect(subject).to receive(:scrape_chapter).with(book, 1)
      subject.send(:scrape_book, book)
    end
  end
  
  describe '#scrape_chapter' do
    
    it 'scrapes book verses' do
      expect(subject).to receive(:scrape_verses).with(book, 1)
      subject.send(:scrape_chapter, book, 1)
    end
  end
  
  describe '#scrape_verses' do
    
    it 'processes verse' do
      expect(subject).to receive(:process_verse).with(book, 1, 1)
      subject.send(:scrape_verses, book, 1)
    end
    
    context 'when verse was not processed' do
      
      before { subject.stub(process_verse: nil) }
      
      it 'returns nil' do
        expect(subject.send(:scrape_verses, book, 1)).to be_nil
      end
    end
    
    context 'when verse was processed' do
      
      let(:verse) { double('verse') }
      before { subject.stub(:process_verse).with(book, 1, 1).and_return(verse) }
      
      it 'recoursively calls the next verse to process' do
        expect(subject).to receive(:process_verse).with(book, 1, 2)
        subject.send(:scrape_verses, book, 1)
      end
    end
  end
  
  describe '#process_verse' do
    
    before { subject.stub(:book_mapping) }
    
    it 'scrapes verse text' do
      expect(subject).to receive(:scrape_verse)
      subject.send(:process_verse, book, 1, 1)
    end
    
    context 'when verse text is not nil' do
      
      before { subject.stub(scrape_verse: 'text') }
      
      it 'creates verse' do
        expect(subject).to receive(:create_verse).with(book, 1, 1, 'text')
        subject.send(:process_verse, book, 1, 1)
      end
    end
    
    context 'when verse text is nil' do
      
      before { subject.stub(scrape_verse: nil) }
      
      it 'returns nil' do
        expect(subject.send(:process_verse, book, 1, 1)).to be_nil
      end
    end
  end
  
  describe '#scrape_verse' do
    
    it 'raises NotImplementedError' do
      expect { subject.send(:scrape_verse, book, 1, 1) }.to raise_error(NotImplementedError)
    end
  end
  
  describe '#create_verse' do
    
    let(:book) { create(:book) }
    
    it 'creates a verse correctly' do
      expect { subject.send(:create_verse, book, 1, 1, 'text') }.to change { book.verses.count }.by(1)
      verse = book.verses.first
      expect(verse.chapter).to eq(1)
      expect(verse.order).to eq(1)
      expect(verse.text_translations[:base]).to eq('text')
    end
  end
  
  describe '#book_mapping' do
    
    before { subject.stub(translation: 'ru') }
    
    context 'when there is a mapping for the book' do
      
      before { book.stub(title: 'Gn') }
      
      it 'returns mapping value' do
        expect(subject.send(:book_mapping, book)).to eq('ge')
      end
    end
    
    context 'when there is no mapping defined' do
      
      before { book.stub(title: 'Le') }
      
      it 'returns downcased book title' do
        expect(subject.send(:book_mapping, book)).to eq('le')
      end
    end
  end
  
  describe '#missing_mappings' do
    
    it 'returns the list of books that need mapping'
  end
end
