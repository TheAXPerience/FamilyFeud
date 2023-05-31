require "./question"
require "./answer"
require "./filemanager"

class CreateManager
    def initialize(filename)
        @filename = filename
        @questions_list = []
    end

    def accept_loop(answer)
        loop do
             print "Enter alternate answer (empty to quit): "
            input = STDIN.gets.chomp.downcase
            if input.length == 0
                break
            end

            answer.addAccepted(input)
        end
    end

    def answer_loop(question)
        loop do
            print "Enter answer (empty to quit): "
            input = STDIN.gets.chomp
            if input.length == 0
                break
            end

            print "Enter points: "
            points = STDIN.gets.chomp.to_i

            answer = Answer.new(input, points)
            answer.addAccepted(input.downcase)
            accept_loop(answer)
            question.addAnswer(answer)
        end
    end

    def question_loop()
        loop do
            print "Enter question (empty to quit): "
            input = STDIN.gets.chomp
            if input.length == 0
                break
            end

            question = Question.new(input)
            answer_loop(question)
            @questions_list << question
        end
    end

    def start()
        puts "Create a new Family Feud-compatible file"
        puts "A file must have at least 8 questions to play a full game"

        # Prompt user for as many questions as they desire
        question_loop()

        # take all questions and answers and save to file
        FileManager.write_file(@filename, @questions_list)
    end
end
