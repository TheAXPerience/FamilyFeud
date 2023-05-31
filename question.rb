require "./answer"

class Question
    attr_reader :question, :answers

    def initialize(question)
        @question = question
        @answers = []
    end

    def addAnswer(answer)
        @answers << answer
    end

    def getSortedAnswers()
        return @answers.sort_by do | answer |
            return -1 * answer.points
        end
    end

    def correct?(answer)
        for a in answers
            return a if a.correct?(answer)
        end
        return nil
    end

    def serialize()
        ans = {}
        ans["question"] = @question
        ans["answers"] = []
        @answers.each do | answer |
            ans["answers"] << answer.serialize()
        end
        return ans
    end
end
