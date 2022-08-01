class Admin::HomesController < ApplicationController
    before_action :authenticate_admin!
def top
    @tag_list =Tag.all.order(created_at: :desc)
end



end
