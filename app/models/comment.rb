class Comment < ApplicationRecord
    belongs_to :post
    belongs_to :customer
    
    validates :comment_content,
        length: { minimum: 1, maximum: 140}, presence: true
end
