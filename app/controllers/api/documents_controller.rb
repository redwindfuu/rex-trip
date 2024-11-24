class Api::DocumentsController < ApplicationController
  def create
    document = Document.new(document_params)
    if document.save
      data = {
        title: document.title,
        link: handle_link(url_for(document.file).to_s),
        created_at: document.created_at,
        id: document.id
      }
      render json: { message: "File uploaded successfully", data: data  }, status: :created
    else
      render json: { error: document.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    document = Document.find(params[:id])
    p ENV["DOMAIN"]
    if document.file.attached?
      to_ = url_for(document.file)
      render json: { link: ENV["DOMAIN"] }, status: :ok
    else
      render json: { error: "File not found" }, status: :not_found
    end
  end

  private

  def document_params
    params.permit(:title, :file)
  end

  def handle_link (link)
    #detach the link from the host
    link.split("://")[1].split("/").drop(1).join("/")
    # link
  end
end
