require "./createmanager"
require "./playmanager"

def print_usage()
    puts "To use this Family Feud application, type in either of the following commands:"
    puts "  1. ruby main.rb create filename.json"
    puts "  2. ruby main.rb play filename.json"
end

def main()
    if ARGV.length != 2
        print_usage()
        return
    elsif ARGV[1].slice(-4, 4) != "json"
        puts "File must be a .json file"
        return
    end

    case ARGV[0]
    when "create"
        CreateManager.new(ARGV[1]).start()
    when "play"
        PlayManager.new(ARGV[1]).start()
    else
        print_usage()
    end
end

main()
