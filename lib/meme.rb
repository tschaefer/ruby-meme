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

  class << self
    ##
    # The static image format, defaults to +png+. <b>[class attribute]</b>
    attr_accessor :image_format_static

    ##
    # The animated image format, defaults to +gif+. <b>[class attribute]</b>
    attr_accessor :image_format_animated
  end

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
  def self.generate(phrase: 'memes, memes everywhere')
    response = post('/images/automatic', body: { text: [phrase] }.to_json)
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
  def initialize(template: 'buzz', caption: ['memes', 'memes everywhere'])
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
      text: @caption,
      extension: @animated ? image_format(:animated) : image_format(:static),
      layout: @top ? 'top' : 'default'
    }
    query.merge!(style: @overlay) if @overlay
    query.merge!(font: @font) if @font
    query.merge!(background:) if background

    query
  end

  def image_format(type)
    case type.to_sym
    when :static
      self.class.image_format_static || 'png'
    when :animated
      self.class.image_format_animated || 'gif'
    end
  end
end
