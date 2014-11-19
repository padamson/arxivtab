require 'spec_helper'

describe "arXiv Search pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "arXiv search" do
    before { visit arxiv_search_path }

    describe "with invalid information" do

      it "should not return search results" do
        before do
          url = ""
          click_button "Search"
        end
        expect { result }.to be_nil
      end

    end

  end
end



