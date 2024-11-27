class Api::DocumentsController < ApplicationController
  def create
    document = Document.new(document_params)
    if document.save!
      data = {
        title: document.title,
        link: url_for(document.file),
        domain: ENV.fetch('DOMAIN', 'http://localhost:8000'),
        path: rails_blob_path(document.file, only_path: true),
        created_at: document.created_at,
        id: document.id
      }
      render_json(data, status: :created)
    else
      raise Errors::Invalid, document.errors.full_messages
    end
  end

  def show
    document = Document.find(params[:id])
    if document.file.attached?
      to_ = url_for(document.file)
      redirect_to to_
    else
      raise Errors::NotFound, "Document not found"
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
