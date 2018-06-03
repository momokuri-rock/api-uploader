class UploaderController < ApplicationController
  before_action :set_file, only: [:show, :destroy, :download, :show]

  def create
    uuid = SecureRandom.uuid
    File.open(file_path(uuid), "w+b") do |fp|
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

  def destroy 
    if File.exists?(@uploaded_file.uuid)
      File.delete(@uploaded_file.uuid) 
    end
    @uploaded_file.destroy
  end

  def show
    render json: @uploaded_file.attributes, status: :ok
  end

  def download 
    stat = File::stat(file_path(@uploaded_file.uuid))
    send_file(file_path(@uploaded_file.uuid), :filename => @uploaded_file.name, :length => stat.size)
  end

  private
  def set_file
    @uploaded_file = UploadedFile.find_by(id: params[:id])
    if !@uploaded_file
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

  def file_path(uuid)
    Rails.root.join("public", uuid)
  end
end
