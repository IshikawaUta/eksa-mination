describe "Fitur Lanjutan eksa-mination" do
  let(:user) { { name: "Budi", Role: "Admin" } }
  subject { [1, 2, 3] }

  describe "let & subject" do
    it "mendukung let dengan caching" do
      expect(user[:name]).to eq("Budi")
    end

    it "mendukung subject" do
      expect(subject).to include(2)
    end
  end

  describe "matcher tambahan" do
    it "mendukung match (regex)" do
      expect("Hello World").to match(/Hello/)
    end

    it "mendukung include" do
      expect([1, 2, 3]).to include(2)
      expect("Ruby").to include("ub")
    end

    it "mendukung raise_error" do
      expect { raise "Boom" }.to raise_error(StandardError, "Boom")
    end

    it "mendukung be_nil, be_truthy, be_falsey" do
      expect(nil).to be_nil
      expect(true).to be_truthy
      expect(false).to be_falsey
    end
  end

  describe "Mocks & Stubs" do
    it "mendukung allow(...).to receive(...).and_return(...)" do
      calc = Object.new
      allow(calc).to receive(:add).and_return(10)
      
      expect(calc.add(1, 1)).to eq(10)
    end
  end
end
