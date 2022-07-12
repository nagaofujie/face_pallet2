class Customer < ApplicationRecord
  has_one_attached :image
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments
  
  def full_name
    self.last_name + " " + self.first_name
  end
  
  def get_image(width, height)
        unless image.attached?
          file_path = Rails.root.join("app/assets/images/no_image.jpeg")
          image.attach(io: File.open(file_path),filename:"default-image.jpg",content_type: "image/jpg")
        end
        image.variant(resize_to_limit:[width, height]).processed
  end
  
  def self.guest
    find_or_create_by!(first_name: "guest", last_name: "customer", email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
    end
  end
  
  

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
