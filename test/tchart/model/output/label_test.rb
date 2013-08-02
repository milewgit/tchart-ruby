require_relative '../../../test_helper'

module TChart
  describe Label, "build_ylabel" do
    it "returns a label with style 'ylabel'" do
      Label.build_ylabel(xy(4,2), 42, "text").style.must_equal "ylabel"
    end
  end
  
  describe Label, "render" do
    before do
      @tex = Tex.new
      @label = Label.build_ylabel(xy(-10,20), xy(30,20), "name")
    end
    
    it "generates TeX code to render and item" do
      @tex.expects(:label)
      @label.render(@tex)
    end
  end
end
