class Calculator
    def calculate(num_one, operator, num_two)
        case operator
        when "+"
            add num_one, num_two
        when "-"
            sub num_one, num_two
        when "/"
            div num_one, num_two
        when "*"
            mult num_one, num_two
        end
    end

    private

    def rationalize(num)
        return num.to_r if (num.is_a? Rational) || (!num.include? "_")

        parts = num.split "_"
        parts[0].to_r + parts[1].to_r
    end

    def add(num_one, num_two)
        rationalize(num_one) + rationalize(num_two)
    end

    def sub(num_one, num_two)
        rationalize(num_one) - rationalize(num_two)
    end

    def div(num_one, num_two)
        rationalize(num_one) / rationalize(num_two)
    end

    def mult(num_one, num_two)
        rationalize(num_one) * rationalize(num_two)
    end
end

class CLI
    attr_reader :error

    def initialize(display_help)
        @calculator = Calculator.new
        @error = false
        @current_input = ""
        help if display_help
    end

    def help
        puts "This program is designed to perform mathematical operations on fractional numbers."
        puts "Ex: '1/2 * 3_3/4' would output 1_7/8"
        puts "To exit the program, enter 'exit' as an input"
    end

    def invalid_input?(input=@current_input)
        input.match(/[a-zA-Z!@#$%^&()=]/) != nil
    end

    def div_by_zero?(input=@current_input)
        input.match(/(\/0)|(\/\s+0)/) != nil
    end

    def validate(input=@current_input)
        if input.downcase.include? 'exit'
            abort("Goodbye!")

        elsif invalid_input? input
            @error = true
            puts "ERROR: Invalid input"

        elsif div_by_zero? input
            @error = true
            puts "ERROR: Divide by zero"

        elsif input.split(/\s+/).size <= 2
            @error = true
            puts "ERROR: Not enough arguments"
        end
    end

    def get!
        print '? '
        @current_input = gets.chomp
    end

    def put
        puts format(@current_input[0])
    end

    def parse!(input=@current_input)
        @current_input = input.split(/\s+/)
    end

    def format(num)
        mix_num = num.numerator / num.denominator
        num -= mix_num

        if num.numerator == 0
            "= " + mix_num.to_s
        elsif mix_num == 0
            "= " + num.to_s
        else
            "= " + mix_num.to_s + "_" + num.to_s
        end
    end

    def calculate!
        operate! method(:next_mult_or_div)
        operate! method(:next_add_or_sub)
    end

    private

    def operate!(which_ops)
        while which_ops.call != nil
            operator_ptr = which_ops.call
            num_one_ptr = operator_ptr - 1
            num_two_ptr = operator_ptr + 1

            num_one = @current_input[num_one_ptr]
            operator = @current_input[operator_ptr]
            num_two = @current_input[num_two_ptr]
            new_num = @calculator.calculate(num_one, operator, num_two)

            @current_input[num_one_ptr] = new_num

            @current_input.delete_at num_two_ptr
            @current_input.delete_at operator_ptr
        end
    end

    def next_mult_or_div
        mult = @current_input.find_index "*"
        div = @current_input.find_index "/"

        if mult.nil? && div.nil?
            return nil
        elsif !div.nil? && (mult.nil? || mult > div)
            return div
        elsif !mult.nil? && (div.nil? || div > mult)
            return mult
        end
    end

    def next_add_or_sub
        add = @current_input.find_index "+"
        sub = @current_input.find_index "-"

        if add.nil? && sub.nil?
            return nil
        elsif !add.nil? && (sub.nil? || sub > add)
            return add
        elsif !sub.nil? && (add.nil? || add > sub)
            return sub
        end
    end
end