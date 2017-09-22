class ReceivedMail < ApplicationRecord
  mount_base64_uploader :Attachments, AttachmentUploader
end
