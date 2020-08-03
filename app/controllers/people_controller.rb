class PeopleController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @people = DynamicsService::List.call
  end

  def edit
    @person = DynamicsService::Fetch.call(person_id: params[:person_id])
  end

  def update
    @person = DynamicsService::Update.call(person_id: params[:person_id], person_name: params[:person_name])
    redirect_to root_path
  end

  def create
    @person = DynamicsService::Create.call(person_name: params[:person_name])
    redirect_to root_path
  end
end
