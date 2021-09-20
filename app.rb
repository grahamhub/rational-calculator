require_relative 'cli'

cli = CLI.new true

while true
    cli.get!
    cli.validate
    if !cli.error
        cli.parse!
        cli.calculate!
        cli.put
    end
end