require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'cli'

class AppTest < MiniTest::Test
    def setup
        @calc = Calculator.new
    end

    def test_add
        assert_equal(3/4r, @calc.calculate("1/2", "+", "1/4"))
        assert_equal(3/2r, @calc.calculate("1", "+", "1/2"))
        assert_equal(7/2r, @calc.calculate("2_3/8", "+", "9/8"))
    end

    def test_sub
        assert_equal(1/4r, @calc.calculate("3/4", "-", "1/2"))
        assert_equal(1/2r, @calc.calculate("1", "-", "1/2"))
        assert_equal(9/4r, @calc.calculate("2_3/8", "-", "1/8"))
    end

    def test_div
        assert_equal(1, @calc.calculate("1/2", "/", "1/2"))
        assert_equal(9, @calc.calculate("3", "/", "1/3"))
        assert_equal(3/4r, @calc.calculate("1_1/2", "/", "2"))
    end

    def test_mult
        assert_equal(1/4r, @calc.calculate("1/2", "*", "1/2"))
        assert_equal(1/2r, @calc.calculate("2", "*", "1/4"))
        assert_equal(15/8r, @calc.calculate("1/2", "*", "3_3/4"))
    end
end