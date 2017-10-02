class SentMail < ApplicationRecord
	mount_base64_uploader :attachment, AttachmentUploader

	validates :sender, :recipient, :subject, :message_body, presence: {message: "Campo obligatorio"}
	validates :sender, :recipient, length: { minimum: 5, too_short: "Este campo requiere al menos 5 caracteres" }
  validates :attachment, file_size: { less_than_or_equal_to: 20.megabytes  }

	def self.sent(params)
		unless params[:urgent]
			byUser(params[:sender]).where(draft: false)
		else
			byUser(params[:sender]).where(draft: false,urgent:params[:urgent])
		end
	end

	def self.byUser(user)
		where(sender: user)
	end

	def self.drafts(params)
		unless params[:urgent]
			byUser(params[:sender]).where(draft: true)
		else
			byUser(params[:sender]).where(draft: true,urgent:params[:urgent])
		end
	end

	def self.urgent(params)
		byUser(params[:sender]).where(draft: false)
	end

	def self.draftAndUrgent(params)
		byUser(params[:sender]).where(draft: true, urgent: true)
	end

	def self.sentId(params)
		where(sender: params[:sender], draft: false).find(params[:id])
	end

	def self.draftsId(params)
		where(sender:params[:sender],draft: true).find(params[:id])
	end

end
