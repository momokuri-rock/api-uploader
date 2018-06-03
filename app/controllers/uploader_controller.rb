class UploaderController < ApplicationController
  before_action :set_file, only: [:show]

  def create
    uuid = SecureRandom.uuid
    File.open(Rails.root.join("public", uuid), "w+b") do |fp|
      fp.write params[:file].read
    end

    # TODO(@rerost) Set size
    uploaded_file = UploadedFile.create(file_params.merge({
      uuid: uuid,
      size: "1000",
    }))

    render json: uploaded_file.attributes, status: :ok
  end

  def index
    @uploaded_files = UploadedFile.all
    render json: {files: @uploaded_files.map { |f| f.attributes }}, status: :ok
  end

  def delete
  end

  def upload
  end

  private
  def set_file
    @uploaded_file = UploadedFile.find_by(uuid: params[:id])
    if !@uploaded_files 
      render json: { error: "Not Found" }, status: :not_found
    end
  end

  def file_params
    params.require(:upload).permit(
        :user_id,
        :name,
        :description,
    )
  end
end
