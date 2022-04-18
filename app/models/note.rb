class Note < ApplicationRecord
	belongs_to :user
	has_many :share_notes, dependent: :destroy
end
