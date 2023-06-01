require "./filemanager"

class PlayManager
    def initialize(filename)
        @filename = filename
        @questions_list = FileManager.read_file(@filename)
    end

    def start_round(question, multiplier=1)
        answers = question.getSortedAnswers()
        left = answers.length
        strikes = 0
        point_total = 0
        curr_team = 0 # randomize

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
        puts "Start a Family Feud game"
        
        for question in @questions_list
            puts question.to_s()
        end
    end
end
