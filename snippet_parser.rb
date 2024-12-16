require 'thor'
require 'yaml'

class SnippetParser < Thor
  desc "convert_snippets INPUT_FILE OUTPUT_FILE", "Convert UltiSnips file to YAML format"

  def convert_snippets(input_file, output_file)
    snippets = []
    snippet = nil

    File.open(input_file, 'r') do |file|
      file.each_line do |line|
        line.strip!

        # Ignore comments and Python code
        next if line.start_with?("#") || line.start_with?("python")

        # If the line contains 'snippet', extract trigger and description
        if line.match(/^snippet\s+(\S+)\s*(.*)/)
          # Save the previous snippet if it exists
          snippets << snippet if snippet

          trigger = $1
          description = $2.strip
          snippet = { trigger: trigger, description: description, code: "", score: 0 }

        # Add lines to code until 'endsnippet' is encountered
        elsif snippet && line.match(/^endsnippet/)
          snippets << snippet
          snippet = nil

        # If inside a snippet, add lines to the code
        elsif snippet
          snippet[:code] += line + "\n"
        end
      end
    end

    # Write the snippets to the output file as YAML
    File.open(output_file, 'w') do |file|
      file.write(snippets.to_yaml)
    end

    puts "Snippets converted and saved to #{output_file}"
  end
end

SnippetParser.start(ARGV)

