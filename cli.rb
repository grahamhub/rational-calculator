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
