class PeopleController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @people = PersonService::List.call
  end

  def edit
    @person = PersonService::Fetch.call(person_id: params[:person_id])
  end

  def update
    @person = PersonService::Update.call(person_id: params[:person_id], person_name: params[:person_name])
    redirect_to root_path
  end

  def create
    @person = PersonService::Create.call(person_name: params[:person_name])
    redirect_to root_path
  end
end
