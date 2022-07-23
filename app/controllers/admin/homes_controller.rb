class Admin::HomesController < ApplicationController
    before_action :authenticate_admin!
def top
    @tag_list =Tag.all
end



end
