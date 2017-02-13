# Token types
#
# EOF (end-of-file) token is used to indicate that
# there is no more input left for lexical analysis
INTEGER, PLUS, EOF = 'INTEGER', 'PLUS', 'EOF'

class Token
  
  attr_accessor :type, :value

  def initialize(type, value)
    # token type: INTEGER, PLUS, or EOF
    @type  = type
    # token value: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, '+', or nil
    @value = value
  end

  def to_s
    """String representation of the class instance

    Examples:
      Token(INTEGER, 3)
      Token(PLUS, '+')
    """
  
    "Token(#{@type}, #{@value})"
  end

end

class Interpreter

  def initialize(text)
    # source text
    @text = text
    # index into text
    @pos = 0
    # current token instance
    @current_token = nil
  end

  def error
    raise StandardError, 'Error parsing input'
  end


  def get_next_token
    """Lexical analyzer (also known as scanner or tokenizer)

    This method is responsible for breaking a sentence apart into tokens.
    One token at a time.
    """

    if @pos > @text.length - 1
      return Token.new(EOF, nil)
    end

    # get the token at this position and decide what token
    # to create based on the single character
    current_char = @text[@pos]

    # if it's a digit convert it to integer and create an INTEGER token
    if current_char =~ /[[:digit:]]/ 
      token = Token.new(INTEGER, current_char.to_i)
      @pos += 1
      return token
    elsif current_char == '+'
      token = Token.new(PLUS, current_char)
      @pos += 1
      return token
    else
      error
    end 
  end

  def eat(token_types)
    # compare the current token type with the passed token type
    # and if they match then "eat" the current token
    # and assign the next token to the @current_token
    # otherwise raise an exception
    if @current_token.type == token_types
      @current_token = get_next_token
    else
      error
    end
  end
  
  def expr
    """expr -> INTEGER PLUS INTEGER"""
    # set current token to the first token taken from the input
    @current_token = get_next_token

    # we expect the current token to be a single-digit integer
    left = @current_token
    eat(INTEGER)

    # we expect the curretn token to be a '+' token
    op = @current_token
    eat(PLUS)

    # we expect the current token to be a single-digit integer
    right = @current_token
    eat(INTEGER)

    # after the above call the @current_token is set to EOF token

    # at this point INTEGER PLUS INTEGER sequence of tokens has been
    # successfully found and the method can just return the result
    # of adding two integers, thus effectively interpreting client input
    if op.type == PLUS
      result = left.value + right.value
    else 
      error
    end

    return result
  end
end

require 'byebug'

def main
  while true
    begin
      print 'calc> '
      text = gets.chomp
    rescue StandardError
      puts "Wrong input, BRo"
    end

    interpreter = Interpreter.new(text)
#    byebug
    result = interpreter.expr
    puts result

  end
end

if $0 == __FILE__
  main
end
