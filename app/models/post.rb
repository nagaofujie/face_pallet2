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
        image.variant(resize_to_limit: [width, height]).processed
    end

 def save_tag(sent_tags)
        current_tags = self.tags.pluck(:name) unless self.tags.nil?
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
        # Postからタイトルまたは説明からあいまい検索
        posts = Post.where(["title LIKE ? OR introduction LIKE ?", "%#{keyword}%", "%#{keyword}%"])

        # Tagからnameをあいまい検索
        tags = Tag.where(["name LIKE ? ", "%#{keyword}%"])

        # 空のidを入れる配列を用意
        post_ids = []

        # post_idsにPostから検索した結果のIDたちを入れる
        post_ids += posts.ids

        # タグのあいまい検索をしたものをループする
        tags.each do |tag|
            # ループしたタグに関連づいている記事をpost_idsに次々と入れる
            post_ids += tag.posts.ids
        end

        # 自分自身(Postモデル)からpost_idsのuniqメソッドで重複を除いたものをすべて取得して返す
        Post.where(id: post_ids.uniq)
    end

end
