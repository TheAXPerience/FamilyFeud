require "./filemanager"

class Team
    attr_accessor :name, :points
    def initialize(name)
        @name = name
        @points = 0
    end
end

class PlayManager
    def initialize(filename)
        @filename = filename
        @questions_list = FileManager.read_file(@filename)
        @teams = []
    end

    def start_round(question, multiplier=1)
        answers = question.getSortedAnswers()
        left = answers.length
        strikes = 0
        point_total = 0
        curr_team = [0, 1].sample()

        # Query both teams to get an answer
        # Continue until one team gets an answer

        # Play until either the team runs out of strikes or guesses all the answers
        while strikes < 3 && left > 0
        end

        # if there are still answers left to guess, allow the other team to attempt to steal
    end

    def start_lightning_round(questions, team)
        point_total = 0

        # ask 5 questions to one player
        # ask the same 5 questions to another player
        # check if total points exceeds 200
    end

    def start()
        if @questions_list.length < 8
            puts "The given file does not contain enough questions to play a game of Family Feud"
            return
        end

        puts "Welcome to the game of Family Feud!"
        @questions_list.shuffle()

        # get team names
        print "Enter the name of the first family: "
        @teams << Team.new(STDIN.gets.chomp)
        print "Enter the name of the second family: "
        @teams << Team.new(STDIN.gets.chomp)
        
        # round 1
        start_round(@questions_list[0], 1)

        # round 2
        start_round(@questions_list[1], 2)

        # round 3
        start_round(@questions_list[2], 3)

        # lightning round
        advancing_team = @teams[0]
        if @teams[1].points > @teams[0].points
            advancing_team = @teams[1]
        elsif @teams[0].points == @teams[1].points
            puts "It's a tie! Winner will be chosen at random!"
            advancing_team = @teams.sample()
        end
        start_lightning_round(@questions_list.slice(3, 5), advancing_team)
    end
end
