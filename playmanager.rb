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

    def print_current_results(question, answers, point_total, strikes=0)
        puts "".center(100, '#')
        puts '# ' + question.question.center(96, ' ') + ' #'
        puts "".center(100, '#')

        answers.each do |answer|
            if answer.answered
                puts '# ' + "#{answer.answer.upcase} (#{answer.points})".center(96, ' ') + ' #'
            else
                puts '# ' + "???".center(96, ' ') + ' #'
            end
            puts "".center(100, '#')
        end

        print '# '
        for i in (1..3)
            if i > strikes
                print ' '
            else
                print 'X'
            end
        end
        puts "TOTAL: #{point_total} #".ljust(95, ' ')
        puts "".center(100, '#') + "\n"
    end

    def print_team_points()
        puts "".center(100, '#')
        print '#'
        print @teams[0].name.upcase.center(48, ' ')
        print '##'
        print @teams[1].name.upcase.center(48, ' ')
        puts '#'
        puts "".center(100, '#')
        print '#'
        print "#{@teams[0].points}".center(48, ' ')
        print '##'
        print "#{teams[1].points}".center(48, ' ')
        puts '#'
        puts "".center(100, '#')
    end

    def start_round(question, multiplier=1)
        answers = question.getSortedAnswers()
        left = answers.length
        strikes = 0
        point_total = 0
        curr_team = [0, 1].sample()

        # Query both teams to get an answer
        # Continue until one team gets an answer
        maxes = [0, 0]
        highest = answers[0].points
        loop do
            if maxes[curr_team] > 0
                break
            end

            puts "#{@teams[curr_team].name}'s turn!"
            puts question.question
            print "Enter guess: "
            guess = gets.chomp.downcase
            ans = question.correct?(guess)
            if ans == nil
                print_current_results(question, answers, point_total, 1)
                curr_team = (curr_team + 1) % 2
            else
                ans.answered = true
                point_total += (ans.points * multiplier)
                left -= 1
                maxes[curr_team] = ans.points
                print_current_results(question, answers, point_total, 0)
                if ans.points == highest
                    break
                end
            end
            puts "".center(100, '-')
        end

        curr_team = maxes[0] > maxes[1] ? 0 : 1
        print "Team #{@teams[curr_team]}, Pass or Play? "
        input = gets.chomp.downcase
        if input == "pass"
            curr_team = (curr_team + 1) % 2
        end

        # Play until either the team runs out of strikes or guesses all the answers
        while strikes < 3 && left > 0
            strikes += 1
        end

        # if there are still answers left to guess, allow the other team to attempt to steal
        if left > 0
            other_team = (curr_team + 1) % 2
            puts "Time to steal, Team #{@teams[other_team].name}!"
            print "Enter guess: "
            guess = gets.chomp.downcase
            ans = question.correct?(guess)
            if ans == nil
                print_current_results(question, answers, point_total, 1)
            else
                ans.answered = true
                print_current_results(question, answers, point_total, 0)
                curr_team = other_team
            end
        end

        # show rest of answers and allocate points
        for ans in answers
            ans.answered = true
        end
        print_current_results(question, answers, point_total)
        @teams[curr_team].points += point_total
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
        print_team_points()
        start_round(@questions_list[0], 1)

        # round 2
        print_team_points()
        start_round(@questions_list[1], 2)

        # round 3
        print_team_points()
        start_round(@questions_list[2], 3)

        # lightning round
        print_team_points()
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
