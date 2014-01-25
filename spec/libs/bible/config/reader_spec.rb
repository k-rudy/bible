require 'spec_helper'

describe Bible::Config::Reader do

  subject { Bible::Config::Reader }

  describe '#import' do

    before do
      subject.stub(config_path: File.expand_path('../../../../support/fixtures/books.yml', __FILE__))
      I18n.locale = :en
    end

    it 'creates a book object correctly' do
      expect(Bible::Book.count).to eq(0)
      subject.import
      bible = Bible::Book.first
      expect(bible.order).to eq(1)
      expect(bible.chapters_count).to eq(50)
      expect(bible.name).to eq('genesis')
      expect(bible.title).to eq('Gn')
      expect(bible.title_full).to eq('Genesis')
    end
  end

  describe '#config_path' do
    it 'can read books config' do
      expect(File.exists? subject.send(:config_path)).to be_true
    end
  end

  describe '#translate_title' do

    let(:book) { { title: { en: { short: 'en_short', full: 'en_full' }, by: { short: 'by_short', full: 'by_full' } } } }

    it 'returns translation structured correctly' do
      expect(subject.send(:translate_title, book, :short)).to eq({
        en: 'en_short',
        by: 'by_short'
      })
    end
  end
end