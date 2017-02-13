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
    puts "Created token of #{type} with #{value}"
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
    # store value of characters that belong to the same token
    @cur_chars = ''
    # current token instance
    @current_token = nil
  end

  def error
    raise StandardError, 'Error parsing input'
  end

  def peek
    """Method that will allow parsing tokens that span multiple
    characters. As long as the characters are of the expected value
    keep parsing gobbling them.
    """
    @text[@pos + 1]
  end

  def get_next_token
    """Lexical analyzer (also known as scanner or tokenizer)

    This method is responsible for breaking a sentence apart into tokens.
    One token at a time.
    """

    if @pos > @text.length - 1
      return Token.new(EOF, nil)
    end

    @cur_chars = ''
    
    # Since we can have tokens that are more than charcter long
    # using infinite loop to gobble as much characters as token
    # has and breaking on boundary
    while true
      # get the token at this position and decide what token
      # to create based on the single character
      current_char = @text[@pos]

      # if it's a digit convert it to integer and create an INTEGER token
      if current_char =~ /[[:digit:]]/ 
        @cur_chars += current_char
        @pos += 1
        # create new token only if next char is not digit
        # and you already saw a digit before
        unless @text[@pos] =~ /[[:digit:]]/
          token = Token.new(INTEGER, @cur_chars.to_i)
          return token
        end
      elsif current_char == '+'
        token = Token.new(PLUS, current_char)
        @pos += 1
        return token
      elsif current_char == '-'
        token = Token.new(MINUS, current_char)
        @pos += 1
        return token
      elsif current_char == ' '
        @pos += 1
      else
        error
      end 
    end
  end

  # in order to simplify expr I allow this method to accept array
  # of token types and if token we are trying to 'eat' is one 
  # of those eat it.
  # But that means that every call to eat has to send an array, even
  # with one element.
  def eat(token_types)
    # compare the current token type with the passed token type
    # and if they match then "eat" the current token
    # and assign the next token to the @current_token
    # otherwise raise an exception
    is_correct = false
    token_types.each do |t|
      if @current_token.type == t
        @current_token = get_next_token
        is_correct = true
      end
    end

    unless is_correct
      error
    end
  end
  
  def expr
    """expr -> INTEGER PLUS INTEGER"""
    # set current token to the first token taken from the input
    @current_token = get_next_token

    # we expect the current token to be a single-digit integer
    left = @current_token
    eat([INTEGER])

    # we expect the curretn token to be a '+' token
    op = @current_token
    eat([PLUS, MINUS])

    # we expect the current token to be a single-digit integer
    right = @current_token
    eat([INTEGER])

    # after the above call the @current_token is set to EOF token

    # at this point INTEGER PLUS INTEGER sequence of tokens has been
    # successfully found and the method can just return the result
    # of adding two integers, thus effectively interpreting client input
    if op.type == PLUS
      result = left.value + right.value
    elsif op.type == MINUS
      result = left.value - right.value
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
