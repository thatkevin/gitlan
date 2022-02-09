require 'gitlan'
RSpec.describe Gitlan, '#fetch_languages' do
  context 'Returning favourite language' do
    it 'returns PHP for thatkevin' do
      gitlan = Gitlan.new
      expect(gitlan.fetch_languages username: 'thatkevin').to eq 'PHP'
    end
    it 'returns C for Linus Torvalds' do
      gitlan = Gitlan.new
      expect(gitlan.fetch_languages username: 'torvalds').to eq 'C'
    end
    it 'returns Dart for nex3' do
      gitlan = Gitlan.new
      expect(gitlan.fetch_languages username: 'nex3').to eq 'Dart'
    end
  end
end