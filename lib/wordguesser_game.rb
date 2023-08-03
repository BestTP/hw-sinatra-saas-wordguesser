class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @correct = ''
    @correct_word = []
    @wrong = ''
    @wrong_word = []
    @answer = ''
    @count = 0
    @status = :play
    @word.length.times {
      @answer += '-'
    }
  end

  def word
    @word
  end

  def guess(letter)
    raise ArgumentError.new('There is no word') if letter == nil || letter.length == 0 || letter =~ /[^a-z]/i

    letter.downcase!

    return false if @correct_word.include?(letter) || @wrong_word.include?(letter)

    if @word.include?(letter)
      @correct_word.append(letter)
      @correct = letter
      @word.split('').each_with_index { |char, idx| @answer[idx] = letter if char == letter }
    else
      @wrong_word.append(letter)
      @wrong = letter
    end
    @status = :win if @answer == @word
    @status = :lose if @count >= 6
    @count += 1
  end

  def word_with_guesses
    @answer
  end

  def guesses
    @correct
  end

  def wrong_guesses
    @wrong
  end

  def check_win_or_lose
    @status
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
