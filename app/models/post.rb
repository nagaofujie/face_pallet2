class Post < ApplicationRecord
    has_one_attached :image
    
    belongs_to :customer
    has_many :favorites, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :post_tags, dependent: :destroy
    has_many :tags, through: :post_tags
    
    validates :title,
        length: { minimum: 1, maximun: 25}, presence: true
    validates :introduction,
        length: { minimum: 1, maximum: 140}, presence: true
    validates :image,
        presence: true
    
    def favorited?(customer)
       favorites.where(customer_id: customer.id).exists?
    end

    def tags_field
        tags.pluck(:name).join(' ')
    end

    def get_image(width, height)
        unless image.attached?
          file_path = Rails.root.join("app/assets/images/no_image.jpeg")
          image.attach(io: File.open(file_path),filename:"default-image.jpg",content_type: "image/jpg")
        end
        image.variant(resize_to_limit:[width, height]).processed
    end
     
 def save_tag(sent_tags)
        current_tags = self.tags.pluck(:tag_list) unless self.tags.nil?
        old_tags = current_tags - current_tags
        new_tags = sent_tags - current_tags
         
    old_tags.each do |old|
        self.tags.delete　Tag.find_by(name: old)
    end
    
    new_tags.each do |new|
        new_post_tag = Tag.find_or_create_by(name: new)
        self.tags << new_post_tag
    end
 end
 
def self.search(keyword)
  where(["title like? OR introduction like?", "%#{keyword}%", "%#{keyword}%"])
end
    
 

end
