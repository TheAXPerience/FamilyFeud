require "./question"
require "./answer"
require "json"

module FileManager
    DEFAULT_FILE = "default.json"
    JSON_OPTIONS = {
        indent: "  ", object_nl: "\n", array_nl: "\n", space: " "
    }

    def self.read_file(filename)
        ql = []
        File.open(filename, "r") do | file |
            payload = JSON.parse(file.read())
            for q in payload
                question = Question.new(q["question"])
                for a in q["answers"]
                    answer = Answer.new(a["answer"], a["points"])
                    for acc in a["accepted"]
                        answer.addAccepted(acc)
                    end
                    question.addAnswer(answer)
                end
                ql << question
            end
        end
        return ql
    end

    def self.write_file(filename, question_list)
        File.open(filename, "w") do | file |
            ql = []
            for question in question_list
                ql << question.serialize()
            end
            file.write(JSON.generate(ql, JSON_OPTIONS))
        end
    end
end
