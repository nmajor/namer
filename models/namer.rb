class Namer
  # nameposer.com
  # namenewb.com

  attr_reader :name, :starter_word

  def initialize starter_word=nil
    @starter_word = starter_word
    @name = generate_name
  end

  def availability
    [ { :name => name }, domains, { :twitter => twitter_available? } ].inject(&:merge)
  end

  def generate_name
    if starter_word && Time.now.to_i % 2 == 0
        first_component = starter_word
    elsif starter_word
      second_component = starter_word
    end

    first_component ||= generate_first_component
    second_component ||= generate_second_component

    first_component + second_component
  end

  def domains
    d = Hash.new
    %w( com net org us co info me ).each do |tld|
      d[tld.to_sym] = domain_available?(tld) ? "available" : "taken"
    end
    d
  end

  def generate_first_component
    random_word
  end

  def generate_second_component
    random_noun
  end

  def random_word
    word = words.sample
  end

  def random_noun
    word = nouns.sample
  end

  def domain_available? tld
    Retriable.retriable :on => Timeout::Error, :tries => 3, :interval => 1 do
      Whois.whois("#{name}.#{tld}").available?
    end
  end

  def twitter_available?
    auth = config["twitter"]
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = auth["consumer_key"]
      config.consumer_secret     = auth["consumer_secret"]
      config.access_token        = auth["access_token"]
      config.access_token_secret = auth["access_token_secret"]
    end

    begin
      return "taken" if client.user(name)
    rescue Twitter::Error::NotFound
      return "available"
    end
  end

  private
    def config
      config = YAML.load_file('config.yml')
    end

    def nouns
      getfile "lib/lists/nounlist.txt"
    end

    def words
      getfile "lib/lists/wordlist.txt"
    end

    def prefixes
      getfile "lib/lists/prefixlist.txt"
    end

    def suffixes
      getfile "lib/lists/suffixlist.txt"
    end

    def getfile list
      File.readlines(list).each {|word| word.delete! "\n"}
    end
end