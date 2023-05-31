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
            -1 * answer.points
        end
    end

    def correct?(answer)
        for a in answers
            return a if a.correct?(answer)
        end
        return nil
    end

    def to_s()
        ret = "#{@question}"
        getSortedAnswers().each do |answer|
            ret += "\n\t#{answer.to_s()}"
        end
        return ret
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
