class CreateReceivedMails < ActiveRecord::Migration[5.1]
  def change
    create_table :received_mails do |t|
      t.string :Sender
      t.string :Recipient
      t.string :Cc
      t.string :Distribution_list
      t.string :Subject
      t.string :Message_body
      t.string :Attachments
      t.datetime :Sent_dateTime
      t.boolean :Read
      t.boolean :Urgent

      t.timestamps
    end
  end
end
