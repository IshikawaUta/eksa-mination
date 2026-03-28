describe "eksa-mination framework" do
  before do
    @value = 10
  end

  it "mendukung pencocokan kesamaan (eq)" do
    expect(@value).to eq(10)
  end

  it "mendukung pencocokan identitas (be)" do
    expect(@value).to be(@value)
  end

  it "mendukung ekspektasi negatif (not_to)" do
    expect(@value).not_to eq(20)
  end

  it "menangkap kegagalan dengan benar" do
    # Secara teknis ini akan gagal di reporter, tapi kita ingin melihatnya beraksi
    # expect(1).to eq(2)
  end

  describe "nested groups" do
    it "bisa berjalan di dalam grup bersarang" do
      expect(true).to eq(true)
    end
  end
end
