# XX

## Project Structure
your_project/
|-- Gemfile
|-- rare_medium/
|   |-- speedtest/
|       |-- json_parser.rb
|       |-- chart.rb
|       |-- bar.rb
|       |-- stacked_bar.rb
|       |-- line.rb
|       |-- scatter.rb
|       |-- pie.rb
|       |-- chart_generator.rb
|-- spec/
|   |-- spec_helper.rb
|   |-- rare_medium/
|       |-- speedtest/
|           |-- json_parser_spec.rb
|           |-- chart_spec.rb
|           |-- bar_spec.rb
|           |-- stacked_bar_spec.rb
|           |-- line_spec.rb
|           |-- scatter_spec.rb
|           |-- pie_spec.rb
|           |-- chart_generator_spec.rb

## Server


## RSpec

Or, if you want to avoid using bundle exec every time, you can add a .rspec file in your project root with the following content:

css
Copy code
--require spec_helper

Ensure Gem Bin Directory in Your PATH:

Make sure that the directory where RubyGems installs executables is in your PATH environment variable. You can add the following line to your shell profile file (like ~/.bash_profile or ~/.zshrc):

bash
Copy code
export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
Then restart your shell or run source ~/.bash_profile (or the equivalent for your shell).


