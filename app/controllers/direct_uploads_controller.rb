class DirectUploadsController < ActiveStorage::DirectUploadsController
    def create
        blob = ActiveStorage::Blob.create_before_direct_upload!(blob_args)
        byebug
    end
end