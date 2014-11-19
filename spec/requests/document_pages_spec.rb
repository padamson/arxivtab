require 'spec_helper'

describe "Document pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "index" do

    before do
      sign_in FactoryGirl.create(:user)
      user.documents.build(url: "http://www.arxiv.org/pdf/1411.3717.pdf") 
      user.documents.build(url: "http://www.arxiv.org/pdf/1411.4048.pdf")
      user.documents.build(url: "http://www.arxiv.org/pdf/1411.4049.pdf")
      visit documents_path
    end

    it { should have_title('All documents') }

    describe "pagination" do

      before(:all) do
         (1..100).each do |n|
           url = FactoryGirl.create(:arxiv, filename: '#{1000+n}.#{1000+n}')
           Document.create(user: :user, url: :url)
         end
      end
      after(:all)  { Document.delete_all }

      let(:first_page)  { Document.paginate(page: 1) }
      let(:second_page) { Document.paginate(page: 2) }

      it { should have_link('Next') }
      its(:html) { should match('>2</a>') }

      it "should list each document" do
        Document.all[0..2].each do |document|
          page.should have_selector('li', text: document.url)
        end
      end

      it "should list the first page of documents" do
        first_page.each do |document|
          page.should have_selector('li', text: document.url)
        end
      end

      it "should not list the second page of documents" do
        second_page.each do |document|
          page.should_not have_selector('li', text: document.url)
        end
      end

      describe "showing the second page" do
        before { visit documents_path(page: 2) }

        it "should list the second page of documents" do
          second_page.each do |document|
            page.should have_selector('li', text: document.url)
          end
        end
      end
    end
  end

  describe "document creation" do
    before do
      visit root_path
      click_link "Add document to tab"
    end

    describe "with invalid information" do

      it "should not create a document" do
        expect { click_button "Add" }.not_to change(Document, :count)
      end

      describe "error messages" do
        before { click_button "Add" }
        it { should have_content('invalid') }
      end
    end

    describe "with valid information" do

      before do
        url = FactoryGirl.create(:arxiv, filename: '1111.111')
        fill_in 'document_url', with: url
      end
      it "should create a document" do
        expect { click_button "Add" }.to change(Document, :count).by(1)
      end
    end
  end
end
