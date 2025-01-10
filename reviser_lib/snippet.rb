# bla bla ba
#
class Snippet
  attr_reader :description, :trigger, :code
  attr_accessor :score

  def initialize(data)
    @description = data[:description]
    @trigger     = data[:trigger]
    @code        = data[:code]
    @score       = data[:score]
  end

  def adjust_score(delta)
    @score = [[@score + delta, -100].max, 100].min
  end

  def to_h
    { description: @description, trigger: @trigger, code: @code, score: @score }
  end

  def display_code
    puts 'Code du snippet :'
    puts code.green
  end

  def process index, snippets_pool
    puts "\nQuestion #{index + 1}:"
    @question = Question.new self, snippets_pool
    set_res
    display_code
    @res
  end

  private

  def set_res
    if @question.ask
      @res = { answers: 1, errors: 0 }
    else
      @res = { answers: 0, errors: 1 }
    end
  end
end
