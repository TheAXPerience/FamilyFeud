require "./answer"
require "test/unit"

class TestAnswer < Test::Unit::TestCase
    def setup()
        @answer1 = Answer.new("Hiccup", 34)
        @answer2 = Answer.new("Ketchup", 32)
        @answer1.addAccepted("hiccup")
        @answer2.addAccepted("ketchup")
        @answer2.addAccepted("condiment")
    end

    def teardown()
    end

    def test_new_answer()
        answer = Answer.new("New", 9)
        assert_equal(answer.answer, "New")
        assert_equal(answer.points, 9)
    end

    def test_add_accepted()
        answer = Answer.new("Mary", 24)
        assert_equal(answer.accepted.length, 0)
        answer.addAccepted("mary")
        assert_equal(answer.accepted.length, 1)
        assert(answer.accepted.include?("mary"))
    end

    def test_serialize()
        ans = @answer2.serialize()
        assert_equal(ans["answer"], @answer2.answer)
        assert_equal(ans["accepted"], @answer2.accepted)
        assert_equal(ans["points"], @answer2.points)
    end

    def test_correct()
        assert(@answer1.correct?("hiccup"))
        assert(@answer2.correct?("ketchup"))
        assert(@answer2.correct?("condiment"))
    end

    def test_not_correct()
        assert(!@answer1.correct?("mushroom"))
        @answer1.answered = true
        assert(!@answer1.correct?("hiccup"))
    end
end
