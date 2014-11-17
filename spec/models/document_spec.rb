require 'spec_helper'

describe Document do

  let(:user) { FactoryGirl.create(:user) }
  before { 
    @document = user.documents.build(url: "http://www.arxiv.org/pdf/1411.3717.pdf") 
  }

  subject { @document }

  it { should respond_to(:url) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @document.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank url" do
    before { @document.url = " " }
    it { should_not be_valid }
  end

  describe "with url that is too long" do
    before { @document.url = "a" * 139 }
    it { should_not be_valid }
  end

  describe "when url format is invalid" do
    it "should be invalid" do
      urls = %w[
        www.arxiv.org/pdf/1111.111.pdf  
        http://arxiv.org/pdf/1111.111.pdf 
        http://www.arxiv.org/paf/1111.111.pdf 
        http://www.arxiv.org/pdf/a1111.111.pdf 
        http://www.arxiv.org/pdf/1111.a111.pdf 
        http://www.arxiv.org/pdf/1111.111.paf 
      ]
      urls.each do |invalid_url|
        @document.url = invalid_url
        @document.should_not be_valid
      end
    end
  end

  describe "when url format is valid" do
    it "should be valid" do
      urls = %w[
        hTtp://www.arxiv.org/pdf/1111.111.pdf  
        http://WWW.arxiv.org/pdf/1111.111.pdf  
        http://www.arxiv.org/PDF/1111.111.pdf  
        http://www.arxiv.org/pdf/2222.111.pdf  
        http://www.arxiv.org/pdf/1111.222.pdf  
        http://www.arxiv.org/pdf/1111.111.PDF
      ]
      urls.each do |valid_url|
        @document.url = valid_url
        @document.should be_valid
      end
    end
  end
end
