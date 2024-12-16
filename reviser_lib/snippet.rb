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

  # Ajuster le score avec des limites
  def adjust_score(delta)
    @score = [[@score + delta, -100].max, 100].min
  end

  # Retourner les données sous forme de hash pour YAML
  def to_h
    { description: @description, trigger: @trigger, code: @code, score: @score }
  end

  # Afficher le code du snippet
  def display_code
    puts 'Code du snippet :'
    puts code.green
  end
end
