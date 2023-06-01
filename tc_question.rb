require "./answer"
require "./question"
require "test/unit"
require "./tc_answer"

class TestQuestion < Test::Unit::TestCase
    def setup()
        @question = Question.new("Name a color.")
        ans1 = Answer.new("Red", 30)
        ans1.addAccepted("red")
        ans2 = Answer.new("Purple", 40)
        ans2.addAccepted("purple")
        ans2.addAccepted("violet")
        ans3 = Answer.new("Blue", 20)
        ans3.addAccepted("blue")
        @question.addAnswer(ans1)
        @question.addAnswer(ans2)
        @question.addAnswer(ans3)
    end

    def test_new_question()
        question = Question.new("New")
        assert_equal(question.question, "New")
        assert_equal(question.answers.length, 0)
    end

    def test_add_answer()
        question = Question.new("New")
        assert_equal(question.answers.length, 0)
        question.addAnswer(Answer.new("A", 17))
        assert_equal(question.answers.length, 1)
        assert_equal(question.answers[0].answer, "A")
        assert_equal(question.answers[0].points, 17)
    end

    def test_get_sorted_answers()
        sa = @question.getSortedAnswers()
        assert_equal(3, sa.length)
        assert_equal("Purple", sa[0].answer)
        assert_equal("Red", sa[1].answer)
        assert_equal("Blue", sa[2].answer)
    end

    def test_serialize()
        q = @question.serialize()
        assert_equal(q["question"], @question.question)
        assert_equal(q["answers"].length, 3)
        assert_equal(q["answers"][0], @question.answers[0].serialize())
        assert_equal(q["answers"][1], @question.answers[1].serialize())
        assert_equal(q["answers"][2], @question.answers[2].serialize())
    end

    def test_correct()
        assert_not_nil(@question.correct?("red"))
        assert_not_nil(@question.correct?("blue"))
        assert_not_nil(@question.correct?("purple"))
        assert_not_nil(@question.correct?("violet"))
    end

    def test_not_correct()
        assert_nil(@question.correct?("green"))
        assert_nil(@question.correct?("orange"))
        @question.answers[1].answered = true
        assert_nil(@question.correct?("purple"))
        assert_nil(@question.correct?("violet"))
    end
end
