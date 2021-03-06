require 'spec_helper'

describe "pages/new.html.erb" do
  before(:each) do
    assign(:page, stub_model(Page,
      :title => "MyString",
      :author => nil,
      :slug => "MyString",
      :content => "MyText",
      :tags => "MyString"
    ).as_new_record)
  end

  it "renders new page form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => pages_path, :method => "post" do
      assert_select "input#page_title", :name => "page[title]"
      assert_select "input#page_author", :name => "page[author]"
      assert_select "input#page_slug", :name => "page[slug]"
      assert_select "textarea#page_content", :name => "page[content]"
      assert_select "input#page_tags", :name => "page[tags]"
    end
  end
end
