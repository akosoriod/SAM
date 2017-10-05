class ReceivedMail < ApplicationRecord
  mount_base64_uploader :attachment, AttachmentUploader

  def self.by_sender(username)
    where(sender: username)
  end

  def self.by_read(read)
    where(read: read)
  end

  def self.by_urgent(urgent)
    where(urgent: urgent)
  end

  def self.paginate(first = 0, max = 10)
    puts "FIRST: #{first}, MAX: #{max}"
    limit(max).offset(first*max)
  end

end
