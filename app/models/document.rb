class Document < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true

  re1='(http)'    # Word 1
  re2='(:)'       # Any Single Character 1
  re3='(\\/)'     # Any Single Character 2
  re4='(\\/)'     # Any Single Character 3
  re5='(www\\.arxiv\\.org)'       # Fully Qualified Domain Name 1
  re6='(\\/)'     # Any Single Character 4
  re7='(pdf)'     # Word 2
  re8='(\\/)'     # Any Single Character 5
  re9='(\\d+)'    # Integer Number 1
  re10='(\\.)'    # Any Single Character 6
  re11='(\\d+)'   # Integer Number 2
  re12='(\\.)'    # Any Single Character 7
  re13='(pdf)'    # Word 3

  re = (re1+re2+re3+re4+re5+re6+re7+re8+re9+re10+re11+re12+re13)
  VALID_URL_REGEX = Regexp.new(re,Regexp::IGNORECASE);

  validates :url, presence: true, length: { maximum: 130 },
    format: { with: VALID_URL_REGEX }

  default_scope -> { order('documents.created_at DESC') }
end
