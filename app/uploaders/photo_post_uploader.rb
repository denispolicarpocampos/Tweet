class PhotoPostUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
  process :convert => 'png'
  
  version :thumb do
    process resize_to_fill: [200,200]
  end
end
