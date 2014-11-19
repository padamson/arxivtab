class DocumentsController < ApplicationController
  before_filter :signed_in_user

  def index
    @documents = Document.all
    @document = Document.new
  end

  def create
    @document = current_user.documents.build(document_params)

    respond_to do |format|
      if @document.save
        format.html do
          flash[:success] = "Document created!"
          redirect_to root_url
        end
        format.json { render action: 'show', status: :created, location: @document }
        format.js do
          render action: 'show', status: :created, location: @document 
          redirect_to root_url
        end
      else
        format.html { render 'static_pages/home' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
        format.js { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private

  def document_params
    params.require(:document).permit(:url)
  end
end
