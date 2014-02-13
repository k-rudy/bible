require 'spec_helper'

describe Bible::Scrapers::Base do
  
  subject { Bible::Scrapers::Base }
  
  # describe '#url' do
 #    
 #    before { subject.stub(translation: 'ru') }
 #    
 #    it 'returns translation url from config' do
 #      expect(subject.url).to be_present
 #    end
 #  end
  
  describe '#translation' do
    
    it 'is evaluated from the class name' do
      expect(subject.translation).to eq('base')
    end
  end
end