class ContactsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @contacts = ContactService::List.call
  end

  def edit
    @contact = ContactService::Fetch.call(contact_id: params[:contact_id])
  end

  def update
    @contact = ContactService::Update.call(contact_id: params[:contact_id], contact_first_name: params[:contact_first_name], contact_last_name: params[:contact_last_name])
    redirect_to root_path
  end

  def create
    @contact = ContactService::Create.call(contact_first_name: params[:contact_first_name], contact_last_name: params[:contact_last_name])
    redirect_to root_path
  end

  def destroy
    ContactService::Delete.call(contact_id: params[:contact_id])
    redirect_to root_path
  end
end
