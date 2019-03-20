class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.max_micropost_length}
  validate  :picture_size

  mount_uploader :picture, PictureUploader

  default_scope ->{order created_at: :desc}
  scope :find_by_user, ->(id){where user_id: id}
  scope :get_feed, ->(id){where user_id: Relationship.select("followed_id").where(follower_id: id)}

  private
    def picture_size
      if picture.size > Settings.max_picture_size_megabytes.megabytes
        errors.add :picture, I18n.t("picture_too_large_error",
          size_megabytes: Settings.max_picture_size_megabytes)
      end
    end
end
