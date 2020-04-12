require_relative '../lib/interpreter_1'

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

  it 'handles EOF token' do
    v = Token.new(EOF, nil)
    expect(v.type).to eq EOF
  end
  
end

describe Interpreter do

  context 'This interpreter handles only single digit integers' do
    it 'handles addition of two integers' do
      itrp = Interpreter.new('3+3')
      expect(itrp.expr).to eq 6
    end
  
    it 'raises error when integer not single digit' do
      itrp = Interpreter.new('-3+3')
      expect { itrp.expr }.to raise_error(StandardError, 'Error parsing input')
    end

    it 'takes first digit from multi digit integer' do
      itrp = Interpreter.new('3+44')
      expect(itrp.expr).to eq 7
    end

    it 'If multi digit integer is in the first place it raises error' do
      itrp = Interpreter.new('34+4')
      expect { itrp.expr }.to raise_error(StandardError, 'Error parsing input')
    end

    it 'Does not handle subtraction' do
      itrp = Interpreter.new('3-4')
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

    it 'Does not handle spaces' do
      itrp = Interpreter.new('3 + 4')
      expect { itrp.expr }.to raise_error(StandardError, 'Error parsing input')
    end
  end
end
