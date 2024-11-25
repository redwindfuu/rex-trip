class Document < ApplicationRecord
  has_one_attached :file

  validate :acceptable_file

  def file_filename
    "#{self.id}_#{Time.now.to_i}"
  end

  def attach_file(file_input)
    self.file.attach(io: file_input, filename: file_filename)
  end

  def acceptable_file
    return unless file.attached?

    unless file.byte_size <= 10.megabytes
      errors.add(:file, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png", "application/pdf"]
    unless acceptable_types.include?(file.content_type)
      errors.add(:file, "must be a JPEG, PNG, or PDF")
    end
  end
end
