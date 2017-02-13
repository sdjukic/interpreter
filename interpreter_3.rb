# Token types
#
# EOF (end-of-file) token is used to indicate that
# there is no more input left for lexical analysis
INTEGER, PLUS, MINUS, EOF = 'INTEGER', 'PLUS', 'MINUS', 'EOF'

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
    @current_char  = @text[@pos]
  end

  ##############################################################################
  # Lexer code                                                                 #
  ##############################################################################

  def error
    raise StandardError, 'Error parsing input'
  end

  def advance
    """Advance the '@pos' pointer and set the '@current_char' variable."""
    @pos += 1
    if @pos > @text.length - 1
      @current_char = nil
    else
      @current_char = @text[@pos]
    end
  end

  def skip_whitespace
    while !@current_char.nil? and @current_char == ' '
      advance
    end
  end

  def integer
    """Return a (multidigit) integer consumed from the input."""
    result = ''
    while !@current_char.nil? and @current_char =~ /[[:digit:]]/
      result += @current_char
      advance
    end

    return result.to_i
  end

  def get_next_token
    """Lexical analyzer (also known as scanner or tokenizer)

    This method is responsible for breaking a sentence apart into tokens.
    One token at a time.
    """

    while !@current_char.nil?
      if @current_char == ' '
        skip_whitespace
        next
      end

      if @current_char =~ /[[:digit:]]/ 
        return Token.new(INTEGER, integer)
      end

      if @current_char == '+'
        advance
        return Token.new(PLUS, '+')
      end

      if @current_char == '-'
        advance
        return Token.new(MINUS, '-')
      end
  
      error
    end

    return Token.new(EOF, nil)
  end

  ##############################################################################
  # Parser / Interpreter code                                                  #
  ##############################################################################
  def eat(token_type)
    # compare the current token type with the passed token type
    # and if they match then "eat" the current token
    # and assign the next token to the @current_token
    # otherwise raise an exception
    if @current_token.type == token_type
      @current_token = get_next_token
    else
      error
    end
  end
  
  def term
    """Return an INTEGER token value"""\
    # Because this is how our grammar defined term
    # right now its only an integer
    token = @current_token
    eat(INTEGER)
    return token.value
  end

  def expr
    """Arithmetic expression parser / interpreter."""
    # set current token to the first token taken from the input
    @current_token = get_next_token

    result = term
    while [PLUS, MINUS].include? @current_token.type 
      token = @current_token
      if token.type == PLUS
        eat(PLUS)
        result = result + term
      elsif token.type == MINUS
        eat(MINUS)
        result = result - term
      end
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
