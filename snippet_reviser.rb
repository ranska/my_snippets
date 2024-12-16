require 'thor'
require 'yaml'
require 'colorize'
require './reviser_lib/snippet'
require './reviser_lib/question'

# bla bla bla
class SnippetReviser < Thor
  desc 'revise_snippets INPUT_FILE', 'Revise snippets based on SM2 method'

  def revise_snippets(input_file)
    @snippets = load_snippets(input_file)
    @correct_answers = 0
    @total_errors = 0

    selected_snippets = @snippets.sample(10)
    process_snippets(selected_snippets)

    save_snippets(input_file)
    display_final_score
  end

  private

  def load_snippets(file)
    YAML.load_file(file).map { |data| Snippet.new(data) }
  end

  def save_snippets(file)
    File.open(file, 'w') do |f|
      f.write(@snippets.map(&:to_h).to_yaml)
    end
  end

  def process_snippets(snippets)
    snippets.each_with_index do |snippet, index|
      puts "\nQuestion #{index + 1}:"
      question = Question.new(snippet, @snippets)
      if question.ask
        @correct_answers += 1
      else
        @total_errors += 1
      end
      snippet.display_code
    end
  end

  def display_final_score
    puts "\nScore global : #{@correct_answers}/10".green
    puts "Erreurs : #{@total_errors}".red
    puts 'Sans faute ! Félicitations !'.bold.green if @correct_answers == 10
  end
end

SnippetReviser.start(ARGV)
