require 'spec_helper'

describe "options/index.html.erb" do
  before(:each) do
    assign(:options, [
      stub_model(Option,
        :key => "Key",
        :value => "MyText"
      ),
      stub_model(Option,
        :key => "Key",
        :value => "MyText"
      )
    ])
  end

  it "renders a list of options" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
