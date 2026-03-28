require_relative '../lib/calculator'

describe "Calculator" do
  before do
    @calc = Calculator.new
  end

  it "bisa menambahkan angka" do
    expect(@calc.add(2, 3)).to eq(5)
  end

  it "bisa mengurangkan angka" do
    expect(@calc.subtract(10, 4)).to eq(6)
  end

  it "bisa mengalikan angka" do
    expect(@calc.multiply(3, 7)).to eq(21)
  end

  it "bisa membagi angka" do
    expect(@calc.divide(10, 2)).to eq(5.0)
  end

  it "mengangkat error saat membagi dengan nol" do
    begin
      @calc.divide(10, 0)
      # Jika tidak raise, gagalkan
      expect(true).to eq(false)
    rescue => e
      expect(e.message).to eq("Division by zero")
    end
  end
end
