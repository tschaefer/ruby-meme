# frozen_string_literal: true

require 'httparty'

##
# A https://memegen.link ruby client.
#
#   Meme.generate(phrase: 'memes, memes everywhere.')
#
#   meme = Meme.new(template: 'buzz', caption: 'memes. memes everywhere')
#   meme.animated = true
#   meme.create
#
# https://api.memegen.link/images/buzz/memes/memes_everywhere.gif
class Meme
  # :nodoc:
  include HTTParty

  base_uri 'https://api.memegen.link'
  headers 'Content-Type' => 'application/json'
  headers 'Accept' => 'application/json'
  # :doc:

  ##
  # The meme template.
  attr_accessor :template

  ##
  # The meme caption text.
  attr_accessor :caption

  ##
  # Whether the meme is animated.
  attr_accessor :animated

  ##
  # The meme overlay.
  attr_accessor :overlay

  ##
  # Whether the meme caption is on top aligned.
  attr_accessor :top

  ##
  # The meme caption font.
  attr_accessor :font

  ##
  # Generate a meme from a phrase.
  def self.generate(phrase: 'memes, memes everywhere.')
    response = post('/images/automatic', body: { text: s_to_a(phrase) }.to_json)
    raise 'Could not generate meme.' if !response.success?

    response.parsed_response['url']
  end

  ##
  # List all available meme templates. Optionally filtered by a keyword and/or
  # the animated flag.
  def self.templates(filter: nil, animated: false)
    response = get('/templates', query: { filter:, animated: })
    raise 'Could not list templates.' if !response.success?

    response.parsed_response
  end

  ##
  # Initialize a new meme.
  def initialize(template: 'buzz', caption: 'memes. memes everywhere')
    @template = template
    @caption  = caption
    @animated = false
    @top = false
  end

  ##
  # Create the meme. If a +background+ image url is provided, the meme will be
  # created with the image instead of the default template.
  def create(background: nil)
    return custom(background) if background

    response = self.class.post('/images', body: query.to_json)
    raise 'Could not create meme.' if !response.success?

    response.parsed_response['url']
  end

  private

  def custom(background)
    response = self.class.post('/images/custom', body: query(background).to_json)
    raise 'Could not create meme.' if !response.success?

    response.parsed_response['url']
  end

  def query(background = nil)
    query = {
      template_id: @template,
      text: self.class.send(:s_to_a, @caption),
      extension: @animated ? 'gif' : 'png',
      layout: @top ? 'top' : 'default'
    }
    query.merge!(style: @overlay) if @overlay
    query.merge!(font: @font) if @font
    query.merge!(background:) if background

    query
  end

  def self.s_to_a(string)
    return string if string.is_a?(Array)

    string.split(/\.|\n/).map(&:strip)
  end

  private_class_method :s_to_a
end
