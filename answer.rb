class Answer
    attr_reader :answer, :accepted, :points
    attr_accessor :answered

    def initialize(answer, points)
        @answer = answer
        @accepted = []
        @points = points
        @answered = false
    end

    def addAccepted(accepted)
        @accepted << accepted
    end

    def correct?(answer)
        return !@answered &&  @accepted.include?(answer)
    end

    def serialize()
        ans = {}
        ans["answer"] = @answer
        ans["accepted"] = @accepted
        ans["points"] = @points
        return ans
    end
end
