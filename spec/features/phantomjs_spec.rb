require 'rails_helper'

RSpec.feature 'phantomjs', js: true do

  def fixture_file_path(arg)
    Rails.root.join "spec/fixtures/#{arg}"
  end

  let(:files) {
    [fixture_file_path("image.png"),
     fixture_file_path("image.png")]
  }

  it "attaches a file to a new temporary file input" do
    visit "/"

    files.each.with_index do |file, idx|

      page.execute_script <<-JS
        input = $('<input/>');
        input.prop('id', "fake#{idx}");
        input.prop('type', 'file');
        input.prependTo('body');
      JS

      raise unless attach_file("fake#{idx}", file)

    end

    expect(page).to have_css "input#fake0"
    expect(page).to have_css "input#fake1"
    expect(find("#fake0").value).to eq "C:\\fakepath\\image.png"
    expect(find("#fake1").value).to eq "C:\\fakepath\\image.png"
  end
end
