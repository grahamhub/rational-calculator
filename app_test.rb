require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'cli'

class AppTest < MiniTest::Test
    def setup
        @calc = Calculator.new
        @cli = CLI.new false
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

    def test_validity
        assert_equal(true, @cli.invalid_input?("hello"))
        assert_equal(false, @cli.invalid_input?("1/2 * 5"))
        assert_equal(true, @cli.invalid_input?("1/2 * test"))
    end

    def test_format
        assert_equal("= 1_1/2", @cli.format(3/2r))
        assert_equal("= 3/4", @cli.format(3/4r))
        assert_equal("= 1", @cli.format(3/3r))
    end

    def test_active
        assert_equal(true, @cli.active)
        @cli.parse! "exit"
        assert_equal(false, @cli.active)
    end

    def test_cli
        @cli.parse! "1/2 * 3_3/4"
        @cli.calculate!
        assert_output("= 1_7/8\n") { @cli.put }
        @cli.parse! "2_3/8 + 9/8"
        @cli.calculate!
        assert_output("= 3_1/2\n") { @cli.put }
        @cli.parse! "2_3/8 + 9/8 * 2 - 1/2 / 3_1/2"
        @cli.calculate!
        assert_output("= 4_27/56\n") { @cli.put }
    end
end