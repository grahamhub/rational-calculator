require_relative 'cli'

cli = CLI.new true

while cli.active
    input = cli.get
    cli.parse! input
    cli.calculate!
    cli.put
end