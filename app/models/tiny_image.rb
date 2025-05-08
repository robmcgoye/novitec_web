class TinyImage < ApplicationRecord
  mount_uploader :file, ImagesUploader
end
