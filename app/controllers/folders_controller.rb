class FoldersController < ApplicationController
  before_filter :authenticate_user!

  def rename
    @folder = current_user.folders.find(params[:id])
    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        format.json { head :no_content } # 204 No Content
      else
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    folder = current_user.folders.find(params[:id])
    folder.state = folder.state
    folder.save
    render nothing: true
  end
end