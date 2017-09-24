class SentMail < ApplicationRecord
	mount_base64_uploader :attachment, AttachmentUploader

	validates :sender, :recipient, :subject, :message_body, presence: {message: "Campo obligatorio"}
	validates :sender, :recipient, length: { minimum: 5, too_short: "Este campo requiere al menos 5 caracteres" }
  validates :attachment, file_size: { less_than_or_equal_to: 20.megabytes  }

	def self.sent
		where(draft: false)
	end

	def self.drafts
		where(draft: true)
	end

	def self.urgent
		where(draft: false,urgent: true)
	end

	def self.draftAndUrgent
		where(draft: true, urgent: true)
	end

	def self.sentId(id)
		sent.where(id: id)
	end

	def self.draftsId(id)
		drafts.where(id: id)
	end

	def self.urgentId(id)
		urgent.where(id: id)
	end

	def self.draftAndUrgentId(id)
		draftAndUrgent.where(id: id)
	end

end
