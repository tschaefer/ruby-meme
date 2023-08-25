# frozen_string_literal: true

require 'spec_helper'

require 'meme'

RSpec.describe Meme, :aggregate_failures do
  around do |example|
    VCR.use_cassette(track.to_s, record: :new_episodes) do
      example.run
    end
  end

  describe '#templates' do
    let(:track) { 'templates' }
    let(:templates) { described_class.templates }
    let(:template) do
      {
        'id' => 'bender',
        'name' => "I'm Going to Build My Own Theme Park",
        'lines' => 2,
        'overlays' => 0,
        'styles' => [],
        'blank' => 'https://api.memegen.link/images/bender.png',
        'example' => {
          'text' => [
            "i'm going to build my own theme park",
            'with blackjack and hookers'
          ],
          'url' => "https://api.memegen.link/images/bender/i'm_going_to_build_my_own_theme_park/with_blackjack_and_hookers.png"
        },
        'source' => 'http://knowyourmeme.com/memes/im-going-to-build-my-own-theme-park-with-blackjack-and-hookers',
        'keywords' => [
          'Futurama'
        ],
        '_self' => 'https://api.memegen.link/templates/bender'
      }
    end

    it 'returns a list of templates' do
      expect(templates).to be_a(Array)
      expect(templates).to include(template)
    end
  end

  describe '#generate' do
    let(:track) { 'generate' }
    let(:url) { described_class.generate(phrase: 'memes, memes everywhere.') }

    it 'returns a url' do
      expect(url).to be_a(String)
      expect(url).to match('https://api.memegen.link/images/buzz/memes/memes_everywhere.webp')
    end
  end

  describe '#create' do
    let(:track) { 'create' }
    let(:meme) { described_class.new(template: 'buzz', caption: ['I can haz', 'potatoe']) }
    let(:url) { meme.create }

    it 'returns a url' do
      expect(url).to be_a(String)
      expect(url).to match('https://api.memegen.link/images/buzz/i_can_haz/potatoe.png')
    end

    context 'with a custom background' do
      let(:track) { 'create_custom' }
      let(:meme) { described_class.new(caption: ['me', 'looking into camera']) }
      let(:url) { meme.create(background: 'https://tschaefer.org/me.jpg') }

      it 'returns a url' do
        expect(url).to be_a(String)
        expect(url).to match('https://api.memegen.link/images/custom/me/looking_into_camera.png?background=https://tschaefer.org/me.jpg')
      end
    end
  end
end
