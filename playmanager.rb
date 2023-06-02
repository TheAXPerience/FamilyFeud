require "./filemanager"
require "./answer"

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
        @questions_list = FileManager.read_file(@filename).shuffle()
        @teams = []
    end

    def print_question(question)
        puts "".center(100, '#')
        puts '# ' + question.question.center(96, ' ') + ' #'
        puts "".center(100, '#')
    end

    def print_current_results(answers, point_total, strikes=0)
        puts "".center(100, '#')
        answers.each_with_index do |answer, index|
            if answer.answered
                puts '#' + "#{answer.answer.upcase}".center(91, ' ') + '#' + "#{answer.points}".center(6, ' ') +  '#'
            else
                puts '# ' + "( #{index+1} )".center(96, ' ') + ' #'
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
        puts "TOTAL: #{point_total} #".rjust(95, ' ')
        puts "".center(100, '#')
        puts
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
        print "#{@teams[1].points}".center(48, ' ')
        puts '#'
        puts "".center(100, '#')
    end

    def start_round(question, multiplier=1)
        answers = question.getSortedAnswers()
        left = answers.length
        strikes = 0
        point_total = 0
        curr_team = [0, 1].sample()

        print_current_results(answers, 0)
        puts "There are #{left} answers on the board!"
        puts "Now, which team shall play?"

        # Query both teams to get an answer
        # Continue until one team gets an answer
        maxes = [0, 0]
        highest = answers[0].points
        loop do
            if maxes[curr_team] > 0
                break
            end
            puts "".center(100, '-')

            puts "Team #{@teams[curr_team].name}'s turn!".rjust(100, ' ')
            print_question(question)
            print "Enter guess: "
            guess = STDIN.gets.chomp.downcase
            ans = question.correct?(guess)
            if ans == nil
                print_current_results(answers, point_total, 1)
                puts "Incorrect!"
            else
                ans.answered = true
                point_total += (ans.points * multiplier)
                left -= 1
                maxes[curr_team] = ans.points
                print_current_results(answers, point_total, 0)
                puts "Correct! That was #{ans.points} points!"
                if ans.points == highest
                    break
                end
            end

            curr_team = (curr_team + 1) % 2
        end

        curr_team = maxes[0] > maxes[1] ? 0 : 1
        puts "".center(100, '-')
        print "Team #{@teams[curr_team].name}, Pass or Play? "
        input = STDIN.gets.chomp.downcase
        if input == "pass"
            curr_team = (curr_team + 1) % 2
        end

        # Play until either the team runs out of strikes or guesses all the answers
        while strikes < 3 && left > 0
            puts "".center(100, '-')
            puts "Team #{@teams[curr_team].name}".rjust(100, ' ')
            print_question(question)
            print "Enter guess: "
            guess = STDIN.gets.chomp.downcase
            ans = question.correct?(guess)
            if ans == nil
                strikes += 1
                print_current_results(answers, point_total, strikes)
                puts "Incorrect!"
            else
                ans.answered = true
                point_total += (ans.points * multiplier)
                left -= 1
                print_current_results(answers, point_total, strikes)
                puts "Correct! That was #{ans.points} points!"
            end
        end

        # if there are still answers left to guess, allow the other team to attempt to steal
        if left > 0
            other_team = (curr_team + 1) % 2
            puts "".center(100, '-')
            puts "Time to steal, Team #{@teams[other_team].name}!".rjust(100, ' ')
            print_question(question)
            print "Enter guess: "
            guess = STDIN.gets.chomp.downcase
            ans = question.correct?(guess)
            if ans == nil
                print_current_results(answers, point_total, 1)
                puts "Incorrect!"
            else
                ans.answered = true
                print_current_results(answers, point_total, 0)
                curr_team = other_team
                puts "Correct!"
            end
        end

        # show rest of answers and allocate points
        puts "Team #{@teams[curr_team].name} gets #{point_total} points!"
        @teams[curr_team].points += point_total

        puts "\nNow for the rest of the answers:"
        for ans in answers
            ans.answered = true
        end
        print_current_results(answers, point_total)
    end

    def start_lightning_round(questions, team)
        puts "".center(100, '-')
        puts "LIGHTNING ROUND!".center(100, ' ')
        point_total = 0

        # TODO: ask 5 questions to one player
        answers_one = []
        answers_two = []

        puts "".center(100, '*')
        puts "Player 1's turn".rjust(100, ' ')
        print "Press Enter To Begin "
        STDIN.gets.chomp
        questions.each do |question|
            print_question(question)
            print "Enter guess: "
            guess = STDIN.gets.chomp.downcase
            ans = question.correct?(guess)
            if ans == nil
                ans = Answer.new("", 0)
            end
            answers_one < [guess, ans]
            point_total += ans.points
        end

        puts "\n" +  " RESULTS ".center(100, '*')
        puts "".center(100, '#')
        for i in (0...5)
            puts '#' + answers_one[i][0].upcase.center(40, ' ') + '#' + "#{answers_one[i][1].points}".center(5, ' ') + '##' + "".center(46, ' ') + '#'
            puts "".center(100, '#')
        end
        puts "TOTAL POINTS: #{point_total}".rjust(100, ' ')

        # TODO: ask the same 5 questions to another player
        puts "".center(100, '*')
        puts "Player 2's turn".rjust(100, ' ')
        print "Press Enter To Begin "
        STDIN.gets.chomp
        questions.each do |question|
            print_question(question)
            same = true
            while same
                print "Enter guess: "
                guess = STDIN.gets.chomp.downcase
                ans = question.correct?(guess)
                if ans == nil
                    ans = Answer.new("", 0)
                end
                # reset loop if equal answer was seen
                same = false
                answer_one.each do |ans1|
                    if ans1[1].equal?(ans)
                        same = true
                    end
                end
                if same
                    puts "Choose another answer."
                end
            end

            answers_two < [guess, ans]
            point_total += ans.points
        end

        puts "".center(100, '#')
        for i in (0...5)
            puts '#' + answers_one[i][0].upcase.center(40, ' ') + '#' + "#{answers_one[i][1].points}".center(5, ' ') + '##' + answers_two[i][0].upcase.center(40, ' ') + '#' + "#{answers_two[i][1].points}".center(5, ' ') + '#'
            puts "".center(100, '#')
        end
        puts '#' + "TOTAL POINTS: #{point_total} #".rjust(99, ' ')
        puts "".center(100, '#')
        puts

        # TODO: check if total points exceeds 200
        puts "".center(100, '*')
        if point_total >= 200
            puts '* ' + "TEAM #{team.name} WINS!".center(96, ' ') + ' *'
        else
            puts '* ' + "BETTER LUCK NEXT TIME, TEAM #{team.name}.".center(96, ' ') + ' *'
        end
    end

    def start()
        if @questions_list.length < 8
            puts "The given file does not contain enough questions to play a game of Family Feud"
            return
        end

        puts "Welcome to the game of Family Feud!"

        # get team names
        print "Enter the name of the first family: "
        @teams << Team.new(STDIN.gets.chomp)
        print "Enter the name of the second family: "
        @teams << Team.new(STDIN.gets.chomp)
        
        # round 1
        puts " SCOREBOARD ".center(100, '*')
        print_team_points()
        puts "\nIt's time for Round 1! Press Enter to continue."
        STDIN.gets
        start_round(@questions_list[0], 1)

        # round 2
        puts " SCOREBOARD ".center(100, '*')
        print_team_points()
        puts "\nIt's time for Round 2! Press Enter to continue."
        STDIN.gets
        start_round(@questions_list[1], 2)

        # round 3
        puts " SCOREBOARD ".center(100, '*')
        print_team_points()
        puts "\nIt's time for Round 3! Press Enter to continue."
        STDIN.gets
        start_round(@questions_list[2], 3)

        # lightning round
        puts " SCOREBOARD ".center(100, '*')
        print_team_points()
        puts
        advancing_team = @teams[0]
        if @teams[1].points > @teams[0].points
            advancing_team = @teams[1]
        elsif @teams[0].points == @teams[1].points
            puts "It's a tie! Winner will be chosen at random!"
            advancing_team = @teams.sample()
        end
        start_lightning_round(@questions_list.slice(3, 5), advancing_team)

        puts "".center(100, '*')
        puts '*' + "Thank you so much for playing!".center(98, ' ') + '*'
        puts "".center(100, '*')
    end
end
