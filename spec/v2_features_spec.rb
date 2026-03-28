unless defined?(APP_VERSION)
  APP_VERSION = "1.0.0"
end

describe "v2.0.0 New Features", :v2 do
  describe "Metadata Tags" do
    it "dijalankan karena memiliki tag :focus", :focus do
      expect(true).to be_truthy
    end

    it "seharusnya difilter jika menjalankan -t focus", :slow do
      # Ini tidak boleh jalan jika -t focus digunakan
      expect(true).to be_truthy
    end
  end

  describe "Constant Stubbing" do
    it "bisa mengganti nilai konstanta global" do
      stub_const("APP_VERSION", "2.0.0-beta")
      expect(APP_VERSION).to eq("2.0.0-beta")
    end

    it "mendukung konstanta bersarang" do
      module MyModule; VERSION = "0.1"; end
      stub_const("MyModule::VERSION", "1.0-final")
      expect(MyModule::VERSION).to eq("1.0-final")
    end
    
    it "restorasi nilai asli setelah tes" do
      # Di tes sebelumnya kita stub APP_VERSION, 
      # tapi mocks.reset (otomatis) harus mengembalikannya ke 1.0.0
      expect(APP_VERSION).to eq("1.0.0")
    end
  end
end
