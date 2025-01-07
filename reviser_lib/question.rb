# bla bla ba
#
class Question
  def initialize(snippet, snippets_pool)
    @snippet       = snippet
    @snippets_pool = snippets_pool
    @question_type = rand(2).zero? ? :trigger : :description
    @options       = generate_options
  end

  # Poser la question et retourner si la réponse est correcte
  def ask
    display_question
    display_options
    user_answer = ask_user_answer
    # TODO: extract method
    if correct_answer?(user_answer)
      puts 'Réponse correcte !'.bold.green
      @snippet.adjust_score(1)
      true
    else
      puts 'Réponse incorrecte.'.bold.red
      @snippet.adjust_score(-2)
      false
    end
  end

  private

  def trigger_question?
    @question_type == :trigger
  end

  def display_question
    if trigger_question?
      puts 'Quel est le trigger correspondant à cette description ?'.bold.yellow
      puts "Description : #{@snippet.description}".bold.yellow
    else
      puts 'Quelle est la description correspondant à ce trigger ?'.bold.blue
      puts "Trigger : #{@snippet.trigger}".bold.blue
    end
  end

  def correct_option
    @snippet.send @question_type
    # (trigger_question? ? @snippet.trigger : @snippet.description)
  end

  def generate_options
    ([correct_option] + pool.sample(3)).shuffle
  end

  def pool
    res = @snippets_pool.map do |snippet|
      snippet.send @question_type
    end
    res.reject { |opt| opt == correct_option }
  end

  def display_options
    @options.each_with_index do |option, index|
      puts "#{index + 1}. #{option}"
    end
  end

  def ask_user_answer
    print 'Choisissez une option (1-4): '
    input = $stdin.gets.chomp
    input.to_i - 1
  end

  def correct_answer? user_answer
    @options[user_answer] == correct_option
  end
end
