require_relative '../../test_helper'

module TChart
  
  describe LayoutBuilder, "build" do
    
    include TestHelper
    
    before do
      @settings = make_settings
      @items = make_items_with_ranges('2000.11.1-2005.3.21', '2002.4.17-2009.3.30')
      @errors = stub
    end
    
    it "returns a layout and errors" do
      LayoutBuilder.stubs(:check_layout).returns @errors
      layout, errors = LayoutBuilder.build(@settings, @items)
      layout.wont_be_nil
      errors.must_be_same_as @errors
    end
    
  end
  
  
  describe LayoutBuilder, "check_layout" do
    
    before do
      @layout = stub
    end
    
    it "returns an error if the plot area is not wide enough" do
      @layout.stubs(:x_axis_length).returns 0
      errors = LayoutBuilder.check_layout(@layout)
      errors.find {|item| item =~ /plot area is too narrow/}.wont_be_nil
    end
    
  end
  
  
  describe LayoutBuilder, "x_axis_tick_dates" do
    
    include TestHelper
    
    before do
      @settings = make_settings
      @this_year = Date.today.year
    end
    
    it "uses 1st January to 31st December when chart items is empty" do
      items = []
      layout, _ = LayoutBuilder.build(@settings, items)
      layout.x_axis_tick_dates.must_equal make_tick_dates(@this_year, @this_year + 1, 1)
    end
    
    it "sets 1st January to 31st December when none of the chart items have date ranges" do
      items = [ stub( date_ranges: [] ) ]
      layout, _ = LayoutBuilder.build(@settings, items)
      layout.x_axis_tick_dates.must_equal make_tick_dates(@this_year, @this_year + 1, 1)
    end
    
    it "sets the correct dates when the items date range is less than 10 years" do
      items = make_items_with_ranges '2000.3.17-2004.10.4'
      layout, _ = LayoutBuilder.build(@settings, items)
      layout.x_axis_tick_dates.must_equal make_tick_dates(2000, 2005, 1)
    end
    
    it "sets the correct dates when the items date range is 10 years" do
      items = make_items_with_ranges '2000.3.17-2009.10.4'
      layout, _ = LayoutBuilder.build(@settings, items)
      layout.x_axis_tick_dates.must_equal make_tick_dates(2000, 2010, 1)
    end
    
    it "sets the correct dates when the items date range is 11 years" do
      items = make_items_with_ranges '2000.3.17-2010.10.4'
      layout, _ = LayoutBuilder.build(@settings, items)
      layout.x_axis_tick_dates.must_equal make_tick_dates(2000, 2015, 5)
    end
    
    it "sets the correct dates when the items date range is less than 50 years" do
      items = make_items_with_ranges '2000.3.17-2044.10.4'
      layout, _ = LayoutBuilder.build(@settings, items)
      layout.x_axis_tick_dates.must_equal make_tick_dates(2000, 2045, 5)
    end
    
    it "sets the correct dates when the items date range is 50 years" do
      items = make_items_with_ranges '2000.3.17-2049.10.4'
      layout, _ = LayoutBuilder.build(@settings, items)
      layout.x_axis_tick_dates.must_equal make_tick_dates(2000, 2050, 5)
    end
    
    it "sets the correct dates when the items date range is less than 60 years" do
      items = make_items_with_ranges '2000.3.17-2054.10.4'
      layout, _ = LayoutBuilder.build(@settings, items)
      layout.x_axis_tick_dates.must_equal make_tick_dates(2000, 2060, 10)
    end
    
    it "sets the correct dates when the items date range is 60 years" do
      items = make_items_with_ranges '2000.3.17-2059.10.4'
      layout, _ = LayoutBuilder.build(@settings, items)
      layout.x_axis_tick_dates.must_equal make_tick_dates(2000, 2060, 10)
    end
    
  end


  describe LayoutBuilder, "x_axis_tick_x_coordinates" do

    include TestHelper

    before do
      @settings = make_settings
      @items = make_items_with_ranges('2000.11.1-2005.3.21', '2002.4.17-2009.3.30')
    end

    it "sets an array of x coordinates" do
      layout, _ = LayoutBuilder.build(@settings, @items)
      layout.x_axis_tick_x_coordinates.must_equal (0..100).step(10.0).to_a
    end

  end


  describe LayoutBuilder, "x_axis_length" do

    include TestHelper

    before do
      @settings = make_settings
      @items = make_items_with_ranges('2000.11.1-2005.3.21', '2002.4.17-2009.3.30')
    end

    it "sets the correct length" do
      layout, _ = LayoutBuilder.build(@settings, @items)
      layout.x_axis_length.must_equal @settings.chart_width - @settings.x_axis_label_width - @settings.y_axis_label_width
    end

  end


  describe LayoutBuilder, "y_axis_length" do

    include TestHelper

    before do
      @settings = make_settings
      @items = make_items_with_ranges('2000.11.1-2005.3.21', '2002.4.17-2009.3.30')
    end

    it "sets the correct length" do
      layout, _ = LayoutBuilder.build(@settings, @items)
      layout.y_axis_length.must_equal @settings.line_height * (@items.length + 1)
    end

  end


  describe LayoutBuilder, "y_axis_label_x_coordinate" do

    include TestHelper

    before do
      @settings = make_settings
      @items = make_items_with_ranges('2000.11.1-2005.3.21', '2002.4.17-2009.3.30')
    end

    it "sets the correct value" do
      layout, _ = LayoutBuilder.build(@settings, @items)
      layout.y_axis_label_x_coordinate.must_equal 0 - ((@settings.y_axis_label_width / 2.0) + (@settings.x_axis_label_width / 2.0))
    end

  end
  

  describe Layout, "y_axis_tick_y_coordinates" do

    include TestHelper

    before do
      @settings = make_settings
      @items = make_items_with_ranges('2000.11.1-2005.3.21', '2002.4.17-2009.3.30')
    end

    it "returns the y coordinates of all items" do
      layout, _ = LayoutBuilder.build(@settings, @items)
      layout.y_axis_tick_y_coordinates.must_equal [8, 4]
    end

  end
end
