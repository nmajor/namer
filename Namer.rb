class Namer
  # nameposer.com
  # namenewb.com

  require 'whois'
  require 'retriable'

  attr_reader :name, :starter_word
  attr_accessor :first_component, :second_component

  def initialize starter_word=nil
    @starter_word = starter_wordx
    @name = generate_name
  end

  def generate_name
    if starter_word
      if Time.now.to_i % 2 == 0
        first_component = starter_word
      else
        second_component = starter_word
      end
    end

    first_component ||= generate_first_component
    second_component ||= generate_second_component

    first_component + second_component
  end

  def domains
    %w( com net org us co info me ).map do |tld|
      [ "#{name}.#{tld}", name_available?(tld) ? 'available' : 'taken' ]
    end
  end

  def generate_first_component
    random_word
  end

  def generate_second_component
    random_noun
  end

  def random_word
    word = words.sample
    prefixes.sample + word if Time.now.to_i % 5
    word + suffixes.sample if Time.now.to_i % 6
  end

  def random_noun
    word = nouns.sample
    prefixes.sample + word if Time.now.to_i % 15
    word + suffixes.sample if Time.now.to_i % 16
  end

  def name_available? tld
    Retriable.retriable :on => Timeout::Error, :tries => 3, :interval => 1 do
      Whois.whois("#{name}.#{tld}").available?
    end
  end

  private
  def nouns
    getfile "nounlist.txt"
  end

  def words
    getfile "wordlist.txt"
  end

  def prefixes
    getfile "prefixlist.txt"
  end

  def suffixes
    getfile "suffixlist.txt"
  end

  def getfile list
    File.readlines(list).each {|word| word.delete! "\n"}
  end
end