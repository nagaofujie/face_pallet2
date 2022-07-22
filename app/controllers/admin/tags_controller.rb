class Admin::TagsController < ApplicationController
    
def destroy
   tag = Tag.find(params[:id])
    tag.destroy
   redirect_to admin_homes_top_path, notice: "completed delete"
end




end



