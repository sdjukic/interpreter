require_relative '../lib/interpreter_3'

describe Token do

  it 'handles Integer types' do
    v = Token.new(INTEGER, 3)
    expect(v.type).to eq INTEGER
    expect(v.value).to eq 3
  end

  it 'handles Integer types' do
    v = Token.new(INTEGER, -5)
    expect(v.type).to eq INTEGER
    expect(v.value).to eq -5
  end

  it 'handles + operator' do
    v = Token.new(PLUS, '+')
    expect(v.type).to eq PLUS
  end

  it 'handles - operator' do
    v = Token.new(MINUS, '-')
    expect(v.type).to eq MINUS
  end

  it 'handles EOF token' do
    v = Token.new(EOF, nil)
    expect(v.type).to eq EOF
  end
  
end

describe Interpreter do

  context 'This interpreter handles only multi digit integers and space' do
    it 'handles addition of two integers' do
      itrp = Interpreter.new('3+3')
      expect(itrp.expr).to eq 6
    end
  
    it 'correctly handles multi-digit integers' do
      itrp = Interpreter.new('3+44')
      expect(itrp.expr).to eq 47
    end

    it 'correctly handles multi-digit integers in any position' do
      itrp = Interpreter.new('34+4')
      expect(itrp.expr).to eq 38
    end

    it 'handles subtraction' do
      itrp = Interpreter.new('3-4')
      expect(itrp.expr).to eq -1
    end

    it 'handles spaces' do
      itrp = Interpreter.new(' 3 + 4 ')
      expect(itrp.expr).to eq 7
    end
  
    it 'handles expressions with more than one operator' do
      itrp = Interpreter.new('3 + 3 + 3 - 1')
      expect(itrp.expr).to eq 8
    end

    it 'Does not handle negative numbers' do
      itrp = Interpreter.new('-3+3')
      expect { itrp.expr }.to raise_error(StandardError, 'Error parsing input')
    end

    it 'Does not handle multiplication' do
      itrp = Interpreter.new('3*4')
      expect { itrp.expr }.to raise_error(StandardError, 'Error parsing input')
    end

    it 'Does not handle division' do
      itrp = Interpreter.new('3/4')
      expect { itrp.expr }.to raise_error(StandardError, 'Error parsing input')
    end

    it 'Does not handle paretheses' do
      itrp = Interpreter.new('(3+4)')
      expect { itrp.expr }.to raise_error(StandardError, 'Error parsing input')
    end
  end
end
