class TagParser
  def self.parse(message)
    tags = message.scan(/\B#\S+/)

    tag_objects = []
    tags.each do |raw_text|
      text = raw_text[1,raw_text.length]
      tag = Tag.where(text: text).first
      tag ||= Tag.create(text: text)
      tag_objects << tag
    end

    tag_objects
  end
end